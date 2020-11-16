extends Node

onready var camera = $Camera2D
onready var music = $Music
onready var hud = $HUD
onready var screens = $Screens
onready var start_position = $StartPosition

const CIRCLE_PS = preload("res://Objects/Circle.tscn")
const JUMPER_PS = preload("res://Objects/Jumper.tscn")
var player
var score : int = 0 setget set_score
var highscore : int = 0
var level : int

func _ready():
	randomize()
	load_highscore()
	hud.hide()

func new_game():
	if Settings.enable_music:
		music.play()
	
	hud.show()
	hud.show_message("Go!")
	
	level = 1
	self.score = -1
	
	camera.position = start_position.position
	player = JUMPER_PS.instance()
	player.position = start_position.position
	
	add_child(player)
	
	player.connect("captured", self, "_on_Jumper_captured")
	player.connect("die", self, "_on_Jumper_die")
	
	spawn_circle(start_position.position)

func spawn_circle(_position = null):
	var circle = CIRCLE_PS.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x, y)
	
	add_child(circle)
	circle.init(_position, level)

func _on_Jumper_captured(area):
	camera.position = area.position
	
	self.score = score + 1
	
	area.capture(player)
	call_deferred("spawn_circle")

func _on_Jumper_die():
	hud.hide()
	if Settings.enable_music:
		music.stop()
	
	get_tree().call_group("circles", "implode")
	
	if score > highscore:
		highscore = score
		save_highscore()
	
	screens.game_over(score, highscore)

func _on_Screens_start_game():
	new_game()

func set_score(value):
	score = value
	hud.update_score(score)
	
	if (score > 0 and score % Settings.circles_per_level == 0):
		level += 1
		hud.show_message("Level %s!" % str(level))

func load_highscore():
	var file = File.new()
	if file.file_exists(Settings.SCORE_FILE):
		file.open(Settings.SCORE_FILE, File.READ)
		highscore = file.get_var()
		file.close()

func save_highscore():
	var file = File.new()
	file.open(Settings.SCORE_FILE, File.WRITE)
	file.store_var(highscore)
	file.close()
