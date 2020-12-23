extends State

onready var duration_timer = $DurationTimer
onready var delay_timer = $DelayTimer
var player

func enter():
	player = fsm.actor
	
	delay_timer.start()

func exit():
	pass

func process(delta):
	pass

func physics_process(delta):
	player.move(delta)

func _on_DurationTimer_timeout():
	fsm.change_state($"../Hang")

func _on_DelayTimer_timeout():
	player.animation_player.play("jump")
	
	player.velocity.y = player.JUMP_ASCEND_SPEED
	player.gravity = player.JUMP_ASCEND_GRAVITY
	duration_timer.start()
