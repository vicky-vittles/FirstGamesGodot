extends Node

var fsm : StateMachine
var animated_sprite

func _ready():
	animated_sprite = $"../../AnimatedSprite"

func enter():
	$DefenseTimer.start()

func exit(next_state):
	fsm.change_state(next_state)

func physics_process(delta):
	animated_sprite.play("protected")

func _on_DefenseTimer_timeout():
	exit($"../Walk")
