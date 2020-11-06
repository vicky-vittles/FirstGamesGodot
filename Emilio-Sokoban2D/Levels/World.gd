extends Node2D

const WALL_PS = preload("res://Entities/Wall.tscn")
const BOX_PS = preload("res://Entities/Box.tscn")
const SPOT_PS = preload("res://Entities/Spot.tscn")
const PLAYER_PS = preload("res://Entities/Player.tscn")

var level_data = {
	width = 0,
	height = 0,
	level = ""
}

onready var spots = $Objects/Spots
onready var blocks = $Objects/Boxes
onready var walls = $Objects/Walls
var player
onready var level_cleared_dialog = $UI/AcceptDialog
onready var level_label = $UI/NameLabel
onready var moves_label = $UI/MovesLabel
onready var completed_sfx = $Completed

var ended_level = false


func _ready():
	build_level(Globals.actual_level)


func build_level(level_id):
	ended_level = false
	level_label.text = "Level " + str(level_id)
	
	var file = File.new()
	file.open("res://Levels/level_" + str(level_id) + ".tres", File.READ)
	var value = file.get_as_text()
	file.close()
	
	level_data = parse_json(value)
	
	var level_layout = level_data.level.strip_escapes().strip_edges(true, true).split(',')
	
	var objects_offset = Vector2()
	objects_offset.x = Globals.TILE_SIZE * ((Globals.SCREEN_WIDTH - level_data.width) / 2)
	objects_offset.y = Globals.TILE_SIZE * ((Globals.SCREEN_HEIGHT - level_data.height) / 2)
	
	var i = 0
	while i < level_layout.size():
		var new_object
		
		var x = Globals.TILE_SIZE * (i % int(level_data.width))
		var y = Globals.TILE_SIZE * int(i / float(level_data.width))
		
		match level_layout[i]:
			"B":
				new_object = BOX_PS.instance()
				blocks.add_child(new_object)
			"F":
				new_object = BOX_PS.instance()
				blocks.add_child(new_object)
				
				level_layout[i] = "S"
				i -= 1
			"W":
				new_object = WALL_PS.instance()
				walls.add_child(new_object)
			"P":
				new_object = PLAYER_PS.instance()
				add_child(new_object)
				
				player = new_object
			"S":
				new_object = SPOT_PS.instance()
				spots.add_child(new_object)
			_:
				pass
		
		if new_object:
			new_object.position = Vector2(x, y) + objects_offset
		
		i += 1


func remove_level():
	for block in blocks.get_children():
		block.queue_free()
	
	for wall in walls.get_children():
		wall.queue_free()
	
	for spot in spots.get_children():
		spot.queue_free()
	
	player.queue_free()


func _process(delta):
	if player:
		moves_label.text = "Moves: " + str(player.steps)
	
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	
	if check_victory() and not ended_level:
		ended_level = true
		completed_sfx.play()
		level_cleared_dialog.show()


func check_victory():
	for child in spots.get_children():
		if not child.occupied:
			return false
	return true


func _on_AcceptDialog_confirmed():
	remove_level()
	Globals.actual_level += 1
	build_level(Globals.actual_level)
