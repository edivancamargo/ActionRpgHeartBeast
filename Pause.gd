extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		set_pause()

func _on_ResumeBtn_pressed():
	set_pause()

func set_pause() -> void:
	var tree = get_tree()
	var paused = not tree.paused
	tree.paused = paused
	visible = paused

func _on_QuitBtn_pressed():
	get_tree().quit()
