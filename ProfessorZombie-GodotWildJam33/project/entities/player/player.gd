extends KinematicBody2D

onready var input_controller = $InputController
onready var character_mover = $CharacterMover
onready var stats = $Stats
onready var graphics = $Graphics
onready var infect_ray = $Triggers/InfectRay

var infect_collider

func check_infect() -> bool:
	infect_ray.force_raycast_update()
	if infect_ray.is_colliding():
		var collider = infect_ray.get_collider()
		if collider.is_in_group("enemy"):
			var enemy_facing = collider.global_transform.x
			var player_facing = character_mover.direction
			var dot = player_facing.dot(enemy_facing)
			if dot > stats.INFECT_EASINESS:
				infect_collider = collider
				return true
	return false
