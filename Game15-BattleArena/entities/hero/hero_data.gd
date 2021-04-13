extends Node

onready var hero = get_parent()

func sync_data():
	var info = make_info()
	rpc_unreliable("update_info", info)

func make_info() -> Dictionary:
	var info = {}
	info["hero_pos"] = hero.global_position
	info["hero_health"] = hero.health.current_health
	
	info["hero_display_name"] = hero.display.display_name
	info["hero_sprite"] = hero.graphics.main_sprite.frame
	info["hero_sprite_pos"] = hero.graphics.main_sprite.global_position
	info["hero_sprite_dir"] = hero.graphics.scale.x
	info["hero_has_gun"] = false
	if hero.gun:
		info["hero_has_gun"] = true
		info["gun_pos"] = hero.gun.graphics.main_sprite.global_position
		info["gun_sprite"] = hero.gun.graphics.main_sprite.frame
		info["gun_sprite_dir"] = -hero.graphics.scale.x
	return info

puppet func update_info(info):
	hero.global_position = info["hero_pos"]
	hero.health.set_health(info["hero_health"])
	hero.display.display_name = info["hero_display_name"]
	hero.graphics.update_info(info)
