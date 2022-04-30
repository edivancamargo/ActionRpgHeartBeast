extends KinematicBody2D

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

var stats = PlayerStats

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _process(delta):
	match state:
		player_state.MOVE:
			run_state(delta)
		player_state.ATTACK:
			attack_state(delta)
		player_state.ROLL:
			roll_state(delta)

func run_state(delta):
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

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished():
	# being called multiple times, check why..
	print("attack animation finished")
	state = player_state.MOVE

func roll_animation_finished():
	# being called multiple times, check why..
	print("roll animation finished")
	velocity = velocity * 0.4 # avoid to much slide at the end of animation
	state = player_state.MOVE

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func move():
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):
	stats.health -= 1
