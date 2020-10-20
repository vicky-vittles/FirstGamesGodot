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

var near_door
export (int) var player_index = 1

var walk_direction = Vector2()
var look_direction = Vector2()
var is_attacking = false

var velocity = Vector2()
var last_direction = Vector2()


func _ready():
	var char_name = character_names[character]
	var folder_name = folder_names[character]
	var gender_name = gender_names[gender]
	
	var file_name = char_name + "_" + gender_name + ".png"
	
	var path = "res://Entities/Player/" + folder_name + "/" + file_name
	
	var sprite_texture = load(path)
	
	$Sprite.texture = sprite_texture


func poll_input():
	
	var p_index = str(player_index)
	
	var horizontal = Input.get_action_strength("l_right_" + p_index) - Input.get_action_strength("l_left_" + p_index)
	var vertical = Input.get_action_strength("l_down_" + p_index) - Input.get_action_strength("l_up_" + p_index)
	var horizontal_look = Input.get_action_strength("r_right_" + p_index) - Input.get_action_strength("r_left_" + p_index)
	var vertical_look = Input.get_action_strength("r_down_" + p_index) - Input.get_action_strength("r_up_" + p_index)
	is_attacking = Input.is_action_pressed("attack_" + p_index)
	
	walk_direction = Vector2(horizontal, vertical).normalized()
	look_direction = Vector2(horizontal_look, vertical_look).normalized()


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

func _on_Hurtbox_area_entered(area):
	
	if area.is_in_group("door"):
		near_door = area.get_node("..")
	
	elif area.is_in_group("collectible"):
		
		var has_been_collected = false
		
		if area.is_in_group("silver_key") and $Inventory.silver_keys < $Inventory.MAX_SILVER_KEYS:
			$Inventory.update_silver_keys(1)
			has_been_collected = true
		
		elif area.is_in_group("gold_key") and $Inventory.gold_keys < $Inventory.MAX_GOLD_KEYS:
			$Inventory.update_gold_keys(1)
			has_been_collected = true
		
		elif area.is_in_group("coin"):
			$Inventory.update_coins(1)
			has_been_collected = true
		
		elif area.is_in_group("life_potion") and $Health.health < $Health.max_health:
			$Health.update_health(1)
			has_been_collected = true
		
		if has_been_collected:
			var collectible = (area as Collectible)
			collectible.get_parent().remove_child(collectible)
			collectible.queue_free()

func _on_InvincibilityTimer_timeout():
	$Hurtbox/CollisionShape2D.set_deferred("disabled", false)

func _on_Hurtbox_area_exited(area):
	
	if area.is_in_group("door"):
		near_door = null
