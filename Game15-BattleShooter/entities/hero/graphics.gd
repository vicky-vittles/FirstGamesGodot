extends Node2D

onready var animation_player = $AnimationPlayer

func play_idle(angle: float):
	var anim_name = "idle" + get_anim_angle(angle)
	animation_player.play(anim_name)

func play_walk(angle: float):
	var anim_name = "walk" + get_anim_angle(angle)
	animation_player.play(anim_name)

func play_weapon(angle: float):
	var anim_name = "look" + get_anim_angle(angle)
	#gun.play_look(anim_name)

func get_anim_angle(angle: float):
	if angle < 0:
		angle += 360

	var anim_name = ""
	var sector = int(posmod((angle+22.5),360)/45)
	match sector:
		0:
			scale.x = 1
			anim_name = "-side"
		1:
			scale.x = 1
			anim_name = "-d-down"
		2:
			scale.x = 1
			anim_name = "-down"
		3:
			scale.x = -1
			anim_name = "-d-down"
		4:
			scale.x = -1
			anim_name = "-side"
		5:
			scale.x = -1
			anim_name = "-d-up"
		6:
			scale.x = 1
			anim_name = "-up"
		7,8:
			scale.x = 1
			anim_name = "-d-up"
	
	return anim_name

func stop_anim():
	animation_player.stop()
