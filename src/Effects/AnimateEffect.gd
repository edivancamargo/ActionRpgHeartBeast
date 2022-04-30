extends AnimatedSprite

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0 # to make sure we start playing the animation in frame 0
	play("Animate") # Animation name has to match it.

func attach(object: Node2D, position: Vector2 = Vector2.ZERO) -> void:
	var root = object.get_tree().current_scene
	root.add_child(self)
	self.global_position = object.global_position
	
	if position != Vector2.ZERO:
		self.set_offset(position)

func _on_animation_finished():
	queue_free()
