extends Node

enum { INNOCENT, ASSASSIN }

# Animations
const HUMAN_IDLE_ANIM = "Idle"
const HUMAN_WALK_ANIM = "Walk-loop"

var DEBUG_MODE : bool = true

func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		DEBUG_MODE = !DEBUG_MODE
		print("Debug Mode: ", DEBUG_MODE)
