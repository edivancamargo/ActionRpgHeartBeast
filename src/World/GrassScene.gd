extends Node2D

var GrassEffect: Resource = preload("res://src/Effects/GrassEffect.tscn")

func _process(delta):
	if Input.is_action_just_pressed("attack_action"):
		var grassEffect: Node2D = GrassEffect.instance() as Node2D
		grassEffect.position = self.position
		get_parent().add_child(grassEffect)

		queue_free()
