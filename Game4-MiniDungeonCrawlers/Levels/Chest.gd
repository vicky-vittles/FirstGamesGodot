extends StaticBody2D

func open():
	$AnimatedSprite.play("open")
	
	var drop = get_node("Collectible")
