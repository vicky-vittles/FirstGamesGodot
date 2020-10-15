extends Area2D

func _ready():
	pass

func _on_Collectible_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		get_parent().remove_child(self)
		queue_free()
