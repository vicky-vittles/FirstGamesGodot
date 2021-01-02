extends KinematicBody2D

class_name Player

enum CHARACTERS {KNIGHT = 0, WIZARD = 1, RANGER = 2, BARBARIAN = 3}
const character_names = ["knight", "wizzard", "elf", "lizard"]
const folder_names = ["Knight", "Wizard", "Ranger", "Barbarian"]
export (CHARACTERS) var character

enum GENDER {MALE = 0, FEMALE = 1}
const gender_names = ["m", "f"]
const gender_names_caps = ["Male", "Female"]
export (GENDER) var gender

const TILE_SIZE = 16
export (int) var HORIZONTAL_DISTANCE_IN_ONE_SECOND = 6
onready var SPEED = TILE_SIZE * HORIZONTAL_DISTANCE_IN_ONE_SECOND

onready var own_character = $Character
onready var objects = $Objects
onready var main_collision_shape = $CollisionShape2D
onready var aim_center = $AimCenter
onready var sprite = own_character.get_node("Sprite")
onready var hurtbox = own_character.get_node("Hurtbox")
onready var hurt_sfx = own_character.get_node("Hurt")
onready var health = own_character.get_node("Health")
onready var animation_player = own_character.get_node("AnimationPlayer")
onready var invincibility_timer = own_character.get_node("InvincibilityTimer")
onready var hurtbox_collision_shape = hurtbox.get_node("CollisionShape2D")
onready var equipped_weapon = objects.get_node("EquippedWeapon")
onready var inventory = objects.get_node("Inventory")
onready var camera = $"../../MultiTargetCamera"

var near_door
export (int) var player_index = 1

var can_poll_input = false

var walk_direction = Vector2()
var look_direction = Vector2()
var is_attacking = false

var velocity = Vector2()
var last_direction = Vector2()

onready var anim_health = health.max_health


func _ready():
	health.connect("update_health", self, "_on_Health_update_health")
	set_sprite()


func set_sprite():
	
	var char_name = character_names[character]
	var folder_name = folder_names[character]
	var gender_name = gender_names[gender]
	
	var file_name = char_name + "_" + gender_name + ".png"
	
	var path = "res://Entities/Player/" + folder_name + "/" + file_name
	
	var sprite_texture = load(path)
	
	sprite.texture = sprite_texture


func poll_input():
	
	if can_poll_input:
		var p_index = str(player_index)
		
		var horizontal = Input.get_action_strength("l_right_" + p_index) - Input.get_action_strength("l_left_" + p_index)
		var vertical = Input.get_action_strength("l_down_" + p_index) - Input.get_action_strength("l_up_" + p_index)
		var horizontal_look = Input.get_action_strength("r_right_" + p_index) - Input.get_action_strength("r_left_" + p_index)
		var vertical_look = Input.get_action_strength("r_down_" + p_index) - Input.get_action_strength("r_up_" + p_index)
		is_attacking = Input.is_action_pressed("attack_" + p_index)
		
		walk_direction = Vector2(horizontal, vertical).normalized()
		look_direction = Vector2(horizontal_look, vertical_look).normalized()


func _physics_process(_delta):
	pass

func turn_around(direction):
	if direction == 1:
		sprite.flip_h = false
		hurtbox.position.x = abs(hurtbox.position.x)
		main_collision_shape.position.x = abs(main_collision_shape.position.x)
	elif direction == -1:
		sprite.flip_h = true
		hurtbox.position.x = -1 * abs(hurtbox.position.x)
		main_collision_shape.position.x = -1 * abs(main_collision_shape.position.x)

func _on_Hurtbox_area_entered(area):
	
	if area.is_in_group("door"):
		near_door = area.get_node("..")
	
	elif area.is_in_group("collectible"):
		
		var has_been_collected = false
		
		if area.is_in_group("silver_key") and inventory.silver_keys < inventory.MAX_SILVER_KEYS:
			inventory.update_silver_keys(1)
			has_been_collected = true
		
		elif area.is_in_group("gold_key") and inventory.gold_keys < inventory.MAX_GOLD_KEYS:
			inventory.update_gold_keys(1)
			has_been_collected = true
		
		elif area.is_in_group("coin"):
			inventory.update_coins(1)
			has_been_collected = true
		
		elif area.is_in_group("life_potion") and health.health < health.max_health:
			health.update_health(2)
			has_been_collected = true
		
		if has_been_collected:
			var collectible = (area as Collectible)
			collectible.collect()

func _on_InvincibilityTimer_timeout():
	hurtbox_collision_shape.set_deferred("disabled", false)

func _on_Hurtbox_area_exited(area):
	if area.is_in_group("door"):
		near_door = null

func _on_Health_update_health(_player_index, new_amount):
	if new_amount < anim_health:
		hurt_sfx.play()
	anim_health = new_amount
