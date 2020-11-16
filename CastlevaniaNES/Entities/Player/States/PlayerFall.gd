extends State

onready var duration_timer = $DurationTimer
var player

func enter():
	player = fsm.actor
	player.animation_player.play("fall")
	
	player.gravity = player.JUMP_DESCEND_GRAVITY
	duration_timer.start()

func exit():
	pass

func process(delta):
	pass

func physics_process(delta):
	player.move(delta)
	
	if player.is_on_floor():
		fsm.change_state($"../Idle")

func _on_DurationTimer_timeout():
	fsm.change_state($"../Idle")
