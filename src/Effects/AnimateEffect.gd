extends AnimatedSprite

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("DestroyEffect")

func attach(object: Node2D) -> void:
	var root = object.get_tree().current_scene
	root.add_child(self)
	self.global_position = object.global_position

func _on_animation_finished():
	queue_free()
