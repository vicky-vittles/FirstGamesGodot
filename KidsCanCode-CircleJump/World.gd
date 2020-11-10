extends Node

onready var hud = $HUD
onready var screens = $Screens
onready var start_position = $StartPosition

const CIRCLE_PS = preload("res://Objects/Circle.tscn")
const JUMPER_PS = preload("res://Objects/Jumper.tscn")
var player
var score : int

func _ready():
	randomize()
	hud.hide()

func new_game():
	hud.show()
	hud.show_message("Go!")
	
	score = -1
	hud.update_score(score)
	
	$Camera2D.position = start_position.position
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
	circle.init(_position)

func _on_Jumper_captured(area):
	$Camera2D.position = area.position
	
	score +=1
	hud.update_score(score)
	
	area.capture(player)
	call_deferred("spawn_circle")

func _on_Jumper_die():
	hud.hide()
	
	get_tree().call_group("circles", "implode")
	screens.game_over()

func _on_Screens_start_game():
	new_game()
