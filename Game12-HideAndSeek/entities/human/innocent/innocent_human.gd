extends "res://entities/human/human.gd"

class_name InnocentHuman, "res://assets/icons/innocent.svg"

export (float) var distance_threshold = 4.0

onready var invisibility = $Invisibility
var assassins


func _ready():
	can_attack = false

func _physics_process(delta):
	check_if_found_by_assassin()

func check_if_found_by_assassin():
	for assassin in assassins:
		var asn_pos = assassin.global_transform.origin
		var my_pos = global_transform.origin
		var is_near = asn_pos.distance_to(my_pos) < distance_threshold
		
		var looking_direction = global_transform.basis.z
		var direction_to_asn = (asn_pos-my_pos).normalized()
		var dot = looking_direction.dot(direction_to_asn)
		print(dot)

func win():
	print("I won!")
