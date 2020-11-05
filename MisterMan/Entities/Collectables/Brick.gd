extends StaticBody2D

func _on_Hurtbox_hit_landed(hit, direction):
	if hit.team == "player_brick":
		queue_free()
