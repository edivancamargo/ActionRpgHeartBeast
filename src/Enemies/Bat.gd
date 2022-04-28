extends KinematicBody2D

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	# area in this case is SwordHitbox.gd (Area2D), so, it has knockback_vector defined over there and
	# we are updating its value in the PLayer.gd
	# I don't like this solution though...
	knockback = area.knockback_vector * 120
