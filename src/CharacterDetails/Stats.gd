extends Node

export(int) var max_health = 1
onready var health: int = max_health setget set_health

signal no_health

func set_health(value) -> void:
	push_error("PRIVATE PROPERTY: Health should not be setted from outside")

func set_damage(damage: int):
	print("set_damage: " + String(damage))
	health = health - damage
	print ("health: " + String(health))
	if health <= 0:
		emit_signal("no_health")
