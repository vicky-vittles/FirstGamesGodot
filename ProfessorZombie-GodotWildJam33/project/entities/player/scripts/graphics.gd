extends Node2D

onready var player = get_parent()
onready var main = $main
onready var infect = $infect
onready var tween = $Tween
onready var animation_player = $AnimationPlayer

func play_infect(target_pos: Vector2):
	animation_player.play("infect")
	tween.interpolate_property(infect, "position", Vector2.ZERO, target_pos, player.stats.INFECT_SPEED)
	tween.start()
