extends Node

const MOVE_SPEED : int = 6*40

export (NodePath) var body_path
onready var body = get_node(body_path)

var direction : Vector2
var velocity : Vector2

func set_direction(_dir):
	direction = _dir

func move(delta):
	velocity = direction * MOVE_SPEED
	velocity = body.move_and_slide(velocity, Vector2.UP)
