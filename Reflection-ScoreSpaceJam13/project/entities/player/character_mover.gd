extends Node

const MOVE_SPEED : int = 5*Globals.PLAYER_SIZE
const DASH_DISTANCE : int = 3*Globals.PLAYER_SIZE
const DASH_TIME : float = 0.15
onready var DASH_SPEED = DASH_DISTANCE / DASH_TIME

export (NodePath) var body_path
onready var body = get_node(body_path)

var direction = Vector2()
var velocity = Vector2()

func _ready():
	assert(body != null)

func set_direction(_dir):
	direction = _dir

func move(delta):
	velocity = direction * MOVE_SPEED
	velocity = body.move_and_slide(velocity, Vector2.UP)

func dash(delta):
	velocity = direction * DASH_SPEED
	velocity = body.move_and_slide(velocity, Vector2.UP)
