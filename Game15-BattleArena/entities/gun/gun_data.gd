extends Node

var bullets_emitted : int = 1 # Bullets emitted
var angle_between_bullets : float = 0 #Angle between bullets, in degrees
var bullet_damage : int = 20 # Damage per bullet
var critical_hit_chance : float = 0.05 # Chance of doing critical shot
var needs_reloading : bool = false # If gun needs reloading between shots
var fire_rate : float = 0.5 # Time between shots
var max_ammo : int = 30 # Max ammo

var BULLET

func load_data(gun_type, gun_variation):
	var data = GunDB.GUNS[gun_type][gun_variation]
	bullets_emitted = data["bullets_emitted"]
	angle_between_bullets = data["angle_between_bullets"]
	bullet_damage = data["bullet_damage"]
	critical_hit_chance = data["critical_hit_chance"]
	needs_reloading = data["needs_reloading"]
	fire_rate = data["fire_rate"]
	max_ammo = data["max_ammo"]
	
	BULLET = GunDB.GUN_BULLETS[gun_type]
