extends State

var human
onready var IDLE = $"../Idle"

func enter():
	human = fsm.actor
	human.graphics.human_animation_player.playback_speed = 0.5
	human.graphics.play_anim(Globals.HUMAN_WALK_ANIM)
	human.character_mover.set_slow_speed()

func exit():
	human.graphics.human_animation_player.playback_speed = 1.0
	human.character_mover.set_run_speed()

func input(event):
	human.event_input(event)

func process(delta):
	human.get_input()

func physics_process(delta):
	human.full_movement(delta)
	if human.input.get_press("walk"):
		fsm.change_state(IDLE)
