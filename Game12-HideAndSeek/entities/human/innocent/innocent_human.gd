extends "res://entities/human/human.gd"
class_name InnocentHuman, "res://assets/icons/innocent.svg"

onready var invisibility = $Invisibility
var vision_of_assassins = {}
var assassins


func _ready():
	can_attack = false

func set_seen_by_assassin(assassin, value):
	vision_of_assassins[assassin] = value

func win():
	print("I won!")
