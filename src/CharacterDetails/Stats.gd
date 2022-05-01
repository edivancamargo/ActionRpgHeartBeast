extends Node

export(int) var max_health = 1 setget set_max_health
onready var health: int = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_health(value: int) -> void:
	health = min(value, max_health)

func set_max_health(value: int) -> void:
	max_health = value
	set_health(value)
	emit_signal("max_health_changed", max_health)

func set_damage(damage: int):
	print("set_damage: " + String(damage))
	self.health = self.health - damage
	print ("health: " + String(self.health))
	emit_signal("health_changed", self.health)
	if self.health <= 0:
		emit_signal("no_health")
