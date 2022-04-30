extends Area2D

export(bool) var show_hit_effect = true

const HitEffect = preload("res://src/Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(area):
	if show_hit_effect:
		HitEffect.instance().attach(self)
