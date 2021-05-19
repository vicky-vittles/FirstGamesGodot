extends KinematicBody2D

signal path_add_point(point)
signal path_clear_points()

onready var input_controller = $InputController
onready var character_mover = $CharacterMover
onready var infect_ray = $Triggers/InfectRay

var infect_threshold : float = -0.9 #25 degrees

func check_infect() -> bool:
	infect_ray.force_raycast_update()
	if infect_ray.is_colliding():
		var collider = infect_ray.get_collider()
		if collider.is_in_group("enemy"):
			var enemy_behind_dir = -1*collider.global_transform.x
			var player_dir = character_mover.direction
			var dot = player_dir.dot(enemy_behind_dir)
			if dot < infect_threshold:
				return true
	return false
