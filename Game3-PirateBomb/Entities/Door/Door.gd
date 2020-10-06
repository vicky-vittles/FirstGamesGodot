extends Area2D

class_name Door

export (NodePath) var door_path
onready var connected_door = get_node(door_path)

var is_being_used = false


func enter():
	if not is_being_used:
		is_being_used = true
		$AnimatedSprite.play("opening")

func close():
	if is_being_used:
		is_being_used = false
		$AnimatedSprite.play("closing")
