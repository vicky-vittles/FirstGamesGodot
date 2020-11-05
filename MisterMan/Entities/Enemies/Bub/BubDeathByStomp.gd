extends Node

var fsm : StateMachine
var animated_sprite

func _ready():
	animated_sprite = $"../../AnimatedSprite"

func enter():
	fsm.actor.disable_shapes()
	
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.connect("timeout", self, "_on_death_timer_timeout")
	add_child(timer)
	timer.start()

func exit(next_state):
	fsm.change_state(next_state)

func process(delta):
	pass

func physics_process(delta):
	animated_sprite.play("squished")

func _on_death_timer_timeout():
	fsm.actor.die()
