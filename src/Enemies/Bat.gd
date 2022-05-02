extends KinematicBody2D

var DeathEffect: Resource = preload("res://src/Effects/DeathEffect.tscn")

export(int) var ACCELERATION: int = 150
export(int) var MAX_SPEED: int = 40
export(int) var FRICTION: int = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var batHurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			set_random_state()
		WANDER:
			wander_state(delta)
		CHASE:
			chase_player(delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 200
	velocity = move_and_slide(velocity)

func wander_state(delta: float) -> void:
	seek_player()
	set_random_state()
	accelerate_toward_point(delta, wanderController.target_position)
	var tolerance = MAX_SPEED * delta
	if global_position.distance_to(wanderController.target_position) <= tolerance:
		set_random_state()

func accelerate_toward_point(delta: float, point: Vector2) -> void:
#	var direction = (player.global_position - global_position).normalized()
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func set_random_state() -> void:
	if wanderController.get_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(1,3))

func seek_player() -> void:
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func chase_player(delta) -> void:
	var player = playerDetectionZone.player as KinematicBody2D
	if player != null:
		accelerate_toward_point(delta, player.global_position)
	else:
		state = IDLE

func _on_Hurtbox_area_entered(area) -> void:
	stats.set_damage(area.damage)
	batHurtbox.create_hit_effect()
	# area in this case is SwordHitbox.gd (Area2D), so, it has knockback_vector defined over there and
	# we are updating its value in the Player.gd
	# I don't like this solution though...
	knockback = area.knockback_vector * 120

func _on_Stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = DeathEffect.instance()
	enemyDeathEffect.position = global_position
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.set_offset(Vector2(0,-14))

func _on_PlayerDetectionZone_body_entered_detection_zone():
	print("listened body_entered_detection_zone signal")
	pass

func _on_PlayerDetectionZone_body_exited_detection_zone():
	print("listened body_exited_detection_zone")
