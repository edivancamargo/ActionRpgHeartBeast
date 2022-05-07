tool
extends Area2D

export(String, FILE) var next_scene_path

func _get_configuration_warning() -> String:
	if next_scene_path == "" or next_scene_path == null:
		return "next_scene_path must be set for the scene transition to work"
	else:
		return ""

func _on_SceneTransition_body_entered(body):
	print("transition zone entered")
	if get_tree().change_scene(next_scene_path) != OK:
		print("Error: Invalid Scene")
