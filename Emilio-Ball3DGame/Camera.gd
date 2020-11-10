extends Camera

var offset
onready var ball = $"../Player"

func _ready():
	offset = translation - ball.translation

func _physics_process(delta):
	translation = ball.translation + offset
