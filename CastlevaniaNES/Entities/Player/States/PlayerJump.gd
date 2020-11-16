extends State

onready var duration_timer = $DurationTimer
var player

func enter():
	player = fsm.actor
	player.animation_player.play("jump")
	
	player.gravity = player.JUMP_ASCEND_GRAVITY
	duration_timer.start()

func exit():
	pass

func process(delta):
	pass

func physics_process(delta):
	player.move(delta)

func _on_DurationTimer_timeout():
	fsm.change_state($"../Hang")
