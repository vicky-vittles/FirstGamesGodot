extends KinematicBody2D

var input

func _process(_delta):
	input = get_node("InputController").get_input()

func _physics_process(delta):
	var direction = input["move_direction"] if input else Vector2.ZERO
	get_node("CharacterMover").set_direction(direction)
	get_node("CharacterMover").move(delta)
