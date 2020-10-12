extends KinematicBody2D

class_name Player

enum CHARACTERS {KNIGHT = 0, WIZARD = 1, RANGER = 2, BARBARIAN = 3}
const character_names = ["knight", "wizzard", "elf", "lizard"]
const folder_names = ["Knight", "Wizard", "Ranger", "Barbarian"]
export (CHARACTERS) var character

enum GENDER {MALE = 0, FEMALE = 1}
const gender_names = ["m", "f"]
export (GENDER) var gender

const TILE_SIZE = 16
export (int) var HORIZONTAL_DISTANCE_IN_ONE_SECOND = 6
onready var SPEED = TILE_SIZE * HORIZONTAL_DISTANCE_IN_ONE_SECOND

export (int) var player_index = 1

var velocity = Vector2()
var last_direction = Vector2()
var look_direction = Vector2()


func _ready():
	var char_name = character_names[character]
	var folder_name = folder_names[character]
	var gender_name = gender_names[gender]
	
	var file_name = char_name + "_" + gender_name + ".png"
	
	var path = "res://Entities/Player/" + folder_name + "/" + file_name
	
	var sprite_texture = load(path)
	
	$Sprite.texture = sprite_texture


func _physics_process(delta):
	pass

func turn_around(direction):
	if direction == 1:
		$Sprite.flip_h = false
		$Hurtbox.position.x = abs($Hurtbox.position.x)
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
	elif direction == -1:
		$Sprite.flip_h = true
		$Hurtbox.position.x = -1 * abs($Hurtbox.position.x)
		$CollisionShape2D.position.x = -1 * abs($CollisionShape2D.position.x)
