extends Node2D

var GrassEffect: Resource = preload("res://src/Effects/GrassEffect.tscn")

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()

func create_grass_effect():
	var grassEffect: Node2D = GrassEffect.instance() as Node2D
	grassEffect.position = self.position
	get_parent().add_child(grassEffect)
	# Doing the same as above but accessing current scene. Not ideal
#	var world = get_tree().current_scene
#	world.add_child(grassEffect)
#	grassEffect.global_position = global_position
