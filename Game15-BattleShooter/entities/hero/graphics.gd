extends Node2D

onready var animation_player = $AnimationPlayer

func play_idle(angle: float):
	if angle < 0:
		angle += 360
	
	var anim_name = ""
	var sector = int(angle/45)
	match sector:
		0:
			scale.x = 1
			anim_name = "idle-side"
		1:
			scale.x = 1
			anim_name = "idle-d-down"
		2:
			scale.x = 1
			anim_name = "idle-down"
		3:
			scale.x = -1
			anim_name = "idle-d-down"
		4:
			scale.x = -1
			anim_name = "idle-side"
		5:
			scale.x = -1
			anim_name = "idle-d-up"
		6:
			scale.x = 1
			anim_name = "idle-up"
		7,8:
			scale.x = 1
			anim_name = "idle-d-up"
	
	animation_player.play(anim_name)

func play_walk(direction: Vector2):
	var x = sign(direction.x)
	var y = sign(direction.y)
	
	if x == 1:
		scale.x = 1
	elif x == -1:
		scale.x = -1
	
	var anim_name = "walk-" + get_direction_name(direction)
	animation_player.play(anim_name)

func get_direction_name(direction: Vector2):
	var x = sign(direction.x)
	var y = sign(direction.y)
	
	var anim_name = ""
	if abs(x) == 1 and y == 0:
		anim_name = "side"
	elif abs(x) == 1 and y == -1:
		anim_name = "d-up"
	elif abs(x) == 1 and y == 1:
		anim_name = "d-down"
	elif x == 0 and y == -1:
		anim_name = "up"
	elif x == 0 and y == 1:
		anim_name = "down"
	
	return anim_name

func stop_anim():
	animation_player.stop()
