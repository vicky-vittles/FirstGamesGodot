extends CanvasLayer

onready var message = $Message
onready var animation_player = $AnimationPlayer
onready var score_box = $ScoreBox
onready var score = $ScoreBox/HBoxContainer/Score

func _ready():
	message.rect_pivot_offset = message.rect_size / 2

func show_message(text):
	message.text = text
	animation_player.play("show_message")

func hide():
	score_box.hide()

func show():
	score_box.show()

func update_score(new_score):
	score.text = str(new_score)
