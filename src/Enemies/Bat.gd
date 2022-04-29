extends KinematicBody2D

onready var stats = $Stats

var knockback = Vector2.ZERO

func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.set_damage(1)
	print(stats.health)
	# area in this case is SwordHitbox.gd (Area2D), so, it has knockback_vector defined over there and
	# we are updating its value in the PLayer.gd
	# I don't like this solution though...
	knockback = area.knockback_vector * 120

func _on_Stats_no_health():
	print("no_health listened")
	queue_free()
