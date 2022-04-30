extends KinematicBody2D

var DeathEffect: Resource = preload("res://src/Effects/DeathEffect.tscn")

onready var stats = $Stats

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.set_damage(area.damage)
	# area in this case is SwordHitbox.gd (Area2D), so, it has knockback_vector defined over there and
	# we are updating its value in the PLayer.gd
	# I don't like this solution though...
	knockback = area.knockback_vector * 120

func _on_Stats_no_health():
	print("no_health listened")
	queue_free()
	var enemyDeathEffect = DeathEffect.instance()
	enemyDeathEffect.position = global_position
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.set_offset(Vector2(0,-14))
