extends "res://entities/human/human.gd"

class_name InnocentHuman, "res://assets/icons/innocent.svg"

export (float) var peripheral_threshold = -0.6
export (float) var distance_threshold = 4.0

onready var invisibility = $Invisibility
var assassins


func _ready():
	can_attack = false

func _physics_process(delta):
	var is_seen_by_assassin = check_if_found_by_assassin()
#	print(is_seen_by_assassin)

func check_if_found_by_assassin():
	for assassin in assassins:
		var asn_pos = assassin.global_transform.origin
		var my_pos = global_transform.origin
		var is_near = asn_pos.distance_to(my_pos) < distance_threshold
		
		var looking_direction = assassin.global_transform.basis.z
		var direction_to_asn = (my_pos-asn_pos).normalized()
		var dot = looking_direction.dot(direction_to_asn)
		var has_vision_on = dot < peripheral_threshold
		
		var has_direct_line_of_sight = false
		assassin.line_of_sight.cast_to = center_pos.global_transform.origin
		assassin.line_of_sight.force_raycast_update()
		var colliding = line_of_sight.is_colliding()
		if colliding:
			var collider = line_of_sight.get_collider()
			print(collider.name)
			if collider.is_in_group("innocent_human"):
				has_direct_line_of_sight = true
#		print(has_direct_line_of_sight)
		
		if is_near and has_vision_on and has_direct_line_of_sight:
			return true
	return false

func win():
	print("I won!")
