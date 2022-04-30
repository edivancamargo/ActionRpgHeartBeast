extends KinematicBody2D

var DeathEffect: Resource = preload("res://src/Effects/DeathEffect.tscn")

export var ACCELERATION: int = 100
export var MAX_SPEED: int = 20
export var FRICTION: int = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var initial_position: Vector2

func _ready():
	initial_position = self.global_position

func _physics_process(delta) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) #Friction
			seek_player(delta)
		WANDER:
			pass
		CHASE:
			chase_player(delta)
			sprite.flip_h = velocity.x < 0
	
	velocity = move_and_slide(velocity)

func seek_player(delta) -> void:
	if playerDetectionZone.can_see_player():
		state = CHASE

func chase_player(delta) -> void:
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		state = IDLE

func return_to_initial_position() -> void:
	print("returning to initial position")
	pass

func _on_Hurtbox_area_entered(area) -> void:
	stats.set_damage(area.damage)
	# area in this case is SwordHitbox.gd (Area2D), so, it has knockback_vector defined over there and
	# we are updating its value in the PLayer.gd
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
	return_to_initial_position()
