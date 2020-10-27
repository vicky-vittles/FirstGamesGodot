extends StaticBody2D

func _ready():
	if has_node("Collectible"):
		$Collectible.disable()

func open():
	$AnimatedSprite.play("open")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "open":
		$Collectible.enable()
	
		var dropped_item = get_node("Collectible")
		dropped_item.global_position = $ItemDropPosition.global_position
	
		get_node("../../DroppedItems").add_child(dropped_item)


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_attack"):
		open()
