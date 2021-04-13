extends Area2D

const GUN = preload("res://entities/gun/Gun.tscn")

export (NodePath) var hero_path
onready var hero = get_node(hero_path)
onready var collision_shape = $CollisionShape

func toggle(is_active: bool):
	collision_shape.disabled = not is_active

func collect(collectable):
	if collectable is GunCollectable:
		# Delete old gun
		if hero.hand.has_node("Gun"):
			var old_gun = hero.hand.get_node("Gun")
			old_gun.name = "OldGun"
			old_gun.queue_free()
			hero.gun = null
		
		# Create new gun
		var new_gun = collectable.make_gun()
		hero.hand.add_child(new_gun)
		hero.gun = new_gun
		
		# Make rpc call
		var gun_info = {
			"gun_type": collectable.gun_type,
			"gun_variation": collectable.gun_variation}
		rpc("make_gun", gun_info)

puppet func make_gun(gun_info):
	# Delete old gun
	if hero.hand.has_node("Gun"):
		var old_gun = hero.hand.get_node("Gun")
		old_gun.name = "OldGun"
		old_gun.queue_free()
		hero.gun = null
	
	# Create new gun
	var new_gun = GUN.instance()
	new_gun.setup(gun_info["gun_type"], gun_info["gun_variation"])
	hero.hand.add_child(new_gun)
	hero.gun = new_gun
