extends Area2D

const HitEffect = preload("res://src/Effects/HitEffect.tscn")

export(Vector2) var offset = Vector2.ZERO

signal invincibility_started
signal invincibility_ended

onready var timer:Timer = $Timer
var invincible: bool = false setget set_invincible

func set_invincible(value: bool) -> void:
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration: float) -> void:
	self.set_invincible(true)
	timer.start(duration)

func create_hit_effect() -> void:
	HitEffect.instance().attach(self, offset)

func _on_Timer_timeout():
	print("_on_Timer_timeout")
	self.set_invincible(false)

# CacGyver solution for enemies entering the hurtbox and not leaving it.
# Below we are disabling monitoring for the collision layers for the duration of the timer...
func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)

func _on_Hurtbox_invincibility_ended():
	monitoring = true
