extends Area2D

var player = null
signal body_exited_detection_zone
signal body_entered_detection_zone

func can_see_player() -> bool:
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	emit_signal("body_entered_detection_zone")
	print("entered detection zone")
	print(body)
	if (body is KinematicBody2D):
		player = body

func _on_PlayerDetectionZone_body_exited(body):
	emit_signal("body_exited_detection_zone")
	print("exited detection zone")
	player = null
