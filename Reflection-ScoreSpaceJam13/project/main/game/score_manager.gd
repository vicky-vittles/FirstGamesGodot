extends Node

const FLOATING_TEXT = preload("res://entities/misc/floating_text.tscn")

signal update_score(score)

onready var game = get_parent()
var five_seconds_score_timer : float

var highscore : int
var score : int


func _ready():
	highscore = Highscore.read()


func _physics_process(delta):
	if game.match_is_on:
		five_seconds_score_timer += delta
		if five_seconds_score_timer >= 5.0:
			five_seconds_score_timer = 0
			plus_survival_score()

func game_over():
	if score > highscore:
		highscore = score
		Highscore.write(score)


func plus_survival_score():
	score += 1000
	emit_signal("update_score", score)
	spawn_floating_text("Survival bonus\n+1000")

func _on_Turrets_turret_destroyed():
	score += 500
	emit_signal("update_score", score)
	spawn_floating_text("Turret destroyed\n+500")

func spawn_floating_text(text):
	var floating_text = FLOATING_TEXT.instance()
	add_child(floating_text)
	floating_text.global_position = game.player.text_spawn_pos.global_position
	floating_text.start(text)
