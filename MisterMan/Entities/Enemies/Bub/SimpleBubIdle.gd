extends Node

var fsm : StateMachine
var animated_sprite

func _ready():
	animated_sprite = $"../../AnimatedSprite"

func enter():
	pass

func exit(next_state):
	fsm.change_state(next_state)

func physics_process(delta):
	animated_sprite.play("idle")

func activate():
	exit($"../Walk")
