extends Node2D

export(int) var wander_range = 32

onready var start_position = global_position
onready var target_position = global_position
onready var timer: Timer = $Timer

func _ready() -> void:
	update_target_position()

func update_target_position() -> void:
	var random_range: float = rand_range(-wander_range, wander_range)
	var target_vector = Vector2(random_range, random_range)
	target_position = target_position + target_vector

func get_time_left() -> float:
	return timer.time_left

func start_wander_timer(duration: float) -> void:
	timer.start(duration)

func _on_Timer_timeout() -> void:
	update_target_position()
