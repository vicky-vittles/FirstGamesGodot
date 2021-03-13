extends State

onready var ACTIVE = $"../Active"
onready var timer = $Timer

var rocket

func enter():
	rocket = fsm.actor
	rocket.animation_player.play("idle")
	rocket.collision_shape.disabled = false
	rocket.hitbox_collision_shape.disabled = false
	rocket.velocity = Vector2()
	Globals.set_cursor_antenna()
	timer.start()

func physics_process(delta):
	rocket.set_target()

func activate():
	rocket.spawn()
	fsm.change_state(ACTIVE)
