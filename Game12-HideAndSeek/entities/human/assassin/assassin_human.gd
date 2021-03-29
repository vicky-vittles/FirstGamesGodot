extends "res://entities/human/human.gd"
class_name AssassinHuman, "res://assets/icons/assassin.svg"

const DIST_TO_HIDING_SPOT_NECESSARY = 4.0

export (int) var visited_hiding_spot_memory = 3
export (float) var peripheral_threshold = -0.6
export (float) var distance_threshold = 4.0

onready var damage_area_shape = $DamageArea/CollisionShape
onready var weapon_animation_player = $Camera/Weapon/AnimationPlayer
var all_hiding_spots = []
var recent_visited_hiding_spots = []
var innocents

func _ready():
	can_attack = true

func _physics_process(delta):
	check_nearby_innocents()
	record_visited_hiding_spots()

func check_nearby_innocents():
	for innocent in innocents:
		# If near innocent
		var my_pos = global_transform.origin
		var ino_pos = innocent.global_transform.origin
		var is_near = my_pos.distance_to(ino_pos) < distance_threshold
		
		# If looking in the direction of the innocent
		var my_looking_direction = global_transform.basis.z
		var direction_to_ino = (ino_pos-my_pos).normalized()
		var dot = my_looking_direction.dot(direction_to_ino)
		var is_directed_at = dot < peripheral_threshold
		
		# If has direct line of sight
		var has_direct_line_of_sight = false
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(
				center_pos.global_transform.origin,
				innocent.center_pos.global_transform.origin)
		if result:
			var collider = result.collider
			if collider.is_in_group("innocent_human"):
				has_direct_line_of_sight = true
		
		var info = {
			Params.IS_NEAR: is_near,
			Params.IS_DIRECTED_AT: is_directed_at,
			Params.HAS_LINE_OF_SIGHT: has_direct_line_of_sight}
		innocent.set_seen_by_assassin(self, info)

func record_visited_hiding_spots():
	for spot in all_hiding_spots:
		var has_visited = has_visited_hiding_spot(spot)
		var is_on_list = recent_visited_hiding_spots.has(spot)
		if has_visited and not is_on_list:
			if recent_visited_hiding_spots.size() >= visited_hiding_spot_memory:
				recent_visited_hiding_spots.pop_front()
			recent_visited_hiding_spots.append(spot)

func has_visited_hiding_spot(spot):
	var spot_pos = spot.global_transform.origin
	var my_pos = global_transform.origin
	var dist_to_spot = spot_pos.distance_to(my_pos)
	return (dist_to_spot <= DIST_TO_HIDING_SPOT_NECESSARY)

func attack_start():
	damage_area_shape.disabled = false
	weapon_animation_player.play("attack")

func attack_end():
	damage_area_shape.disabled = true
