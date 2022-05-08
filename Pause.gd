extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		var tree = get_tree()
		var paused = not tree.paused
		tree.paused = paused
		visible = paused
