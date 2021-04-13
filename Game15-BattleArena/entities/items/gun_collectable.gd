extends "res://entities/items/collectable.gd"
class_name GunCollectable

const GUN = preload("res://entities/gun/Gun.tscn")

var gun_type : int
var gun_variation : int

func _ready():
	gun_type = randi()%6
	gun_variation = (randi()%3) + 1

func make_gun():
	var gun = GUN.instance()
	gun.setup(gun_type, gun_variation)
	return gun
