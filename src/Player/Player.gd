extends KinematicBody2D

const PlayerHurtSound = preload("res://src/Player/PlayerHurtSound.tscn")
const ACCELERATION = 500
const MAX_SPEED = 80
const ROLL_SPEED = MAX_SPEED * 1.1
const FRICTION = 500

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

enum player_state {
	MOVE,
	ROLL,
	ATTACK
}

var state = player_state.MOVE

# PlayerStats is a global autoload singleton
var playerStats = PlayerStats

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var playerHurtbox = $Hurtbox
onready var blinck_animation = $BlinkAnimation

func _ready():
	playerStats.connect("no_health", self, "dead")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _process(delta):
	match state:
		player_state.MOVE:
			running_state(delta)
		player_state.ATTACK:
			attacking_state(delta)
		player_state.ROLL:
			rolling_state(delta)

func dead() -> void:
	print("dead")
	queue_free()

func running_state(delta) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

	move()
	
	if Input.is_action_just_pressed("attack_action"):
		state = player_state.ATTACK
		
	if Input.is_action_just_pressed("roll_action"):
		state = player_state.ROLL

func attacking_state(delta) -> void:
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished() -> void:
	# being called multiple times, check why..
	print("attack animation finished")
	state = player_state.MOVE

func roll_animation_finished() -> void:
	# being called multiple times, check why..
	print("roll animation finished")
	velocity = velocity * 0.4 # avoid to much slide at the end of animation
	state = player_state.MOVE

func rolling_state(delta) -> void:
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func move() -> void:
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area) -> void:
#	Area in this case is Hitbox
	playerStats.set_damage(area.damage)
	playerHurtbox.start_invincibility(0.7)
	playerHurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_Hurtbox_invincibility_started():
	blinck_animation.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinck_animation.play("Stop")
