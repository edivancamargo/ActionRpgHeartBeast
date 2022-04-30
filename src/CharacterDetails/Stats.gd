extends Node

export(int) var max_health = 1
onready var health = max_health setget set_damage

signal no_health

func set_damage(damage: int):
	health = health - damage
	if health <= 0:
		emit_signal("no_health")
