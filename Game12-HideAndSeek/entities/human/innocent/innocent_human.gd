extends "res://entities/human/human.gd"

class_name InnocentHuman, "res://assets/icons/innocent.svg"

onready var invisibility = $Invisibility

func _ready():
	can_attack = false

func win():
	print("I won!")
