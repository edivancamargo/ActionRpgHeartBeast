extends Control

#onready var label: Label = $Label
onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

var hearts: int setget set_hearts
var max_hearts: int setget set_max_hearts

func _ready() -> void:
	self.set_max_hearts(PlayerStats.max_health)
	self.set_hearts(PlayerStats.health)
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")

func set_hearts(value: int) -> void:
	hearts = clamp(value, 0, max_hearts)
#	How to Update a label node
#	if label != null:
#		label.text = "HP: " + str(hearts)
	if heartUIFull != null:
#		Texture is 15w x 11h, this is the reason why we use 15 below
		heartUIFull.rect_size.x = hearts * 15
	
func set_max_hearts(value: int) -> void:
	max_hearts = max(value, 1)
	self.hearts = min(value, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15
