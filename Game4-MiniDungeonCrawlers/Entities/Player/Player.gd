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
onready var position_for_bot = $PositionForBot
onready var sprite = own_character.get_node("Sprite")
onready var enemy_detector = own_character.get_node("EnemyDetector")
onready var hurtbox = own_character.get_node("Hurtbox")
onready var hurt_sfx = own_character.get_node("Hurt")
onready var health = own_character.get_node("Health")
onready var animation_player = own_character.get_node("AnimationPlayer")
onready var invincibility_timer = own_character.get_node("InvincibilityTimer")
onready var hurtbox_collision_shape = hurtbox.get_node("CollisionShape2D")
onready var equipped_weapon = objects.get_node("EquippedWeapon").get_child(0)
onready var inventory = objects.get_node("Inventory")
var virtual_controller
var main_player
var dual_button
var is_bot : bool

var nearest_enemies = []
var near_door
export (int) var player_index = 1

var can_poll_input = false

var cheats_enabled = true
var noclip_enabled = false
var invincible_enabled = false

var walk_direction = Vector2()
var look_direction = Vector2()
var is_attacking = false

var velocity = Vector2()
var last_direction = Vector2()

onready var anim_health = health.max_health


func _ready():
	virtual_controller = get_node("VirtualController")
	health.connect("update_health", self, "_on_Health_update_health")
	set_sprite()


func _process(_delta):
	if cheats_enabled:
		if Input.is_action_just_pressed("cheat_noclip"):
			noclip_enabled = !noclip_enabled
			print("noclip is " + str(noclip_enabled))
			main_collision_shape.set_deferred("disabled", noclip_enabled)
		
		if Input.is_action_just_pressed("cheat_invincible"):
			invincible_enabled = !invincible_enabled
			print("invincibility is " + str(invincible_enabled))
			hurtbox_collision_shape.set_deferred("disabled", invincible_enabled)


func _physics_process(delta):
	if walk_direction != Vector2.ZERO:
		position_for_bot.position = walk_direction * -30


func set_sprite():
	
	var char_name = character_names[character]
	var folder_name = folder_names[character]
	var gender_name = gender_names[gender]
	
	var file_name = char_name + "_" + gender_name + ".png"
	
	var path = "res://Entities/Player/" + folder_name + "/" + file_name
	
	var sprite_texture = load(path)
	
	sprite.texture = sprite_texture


func poll_input():
	if virtual_controller:
		virtual_controller.get_input()


func get_other_players():
	var all_players = get_parent().get_children()
	var other_players = []
	for p in all_players:
		if p != self:
			other_players.append(p)
	return other_players


func get_main_player():
	var other_players = get_other_players()
	var non_cpu_players = []
	for p in other_players:
		if not p.is_bot:
			non_cpu_players.append()
	
	if non_cpu_players.size() == 1:
		return non_cpu_players[0]
	
	non_cpu_players.sort_custom(Globals, "sort_by_health")


func get_nearest_enemy():
	if nearest_enemies.size() == 0:
		return null
	
	var enemy_distances = []
	for e in nearest_enemies:
		enemy_distances.append([e, global_position.distance_to(e.global_position)])
	
	enemy_distances.sort_custom(Globals, "sort_by_distance")
	return enemy_distances[0][0]


func get_player_with_dual_button():
	var other_players = get_other_players()
	for p in other_players:
		if p != self and p.dual_button:
			return p


func move_to(target_pos):
	var distance_to_target = self.global_position.distance_to(target_pos)
	if distance_to_target > 5:
		var direction_to_target = self.global_position.direction_to(target_pos).normalized()
		walk_direction = direction_to_target
	else:
		walk_direction = Vector2.ZERO


func attack_target(target_pos):
	var distance_to_target = self.global_position.distance_to(target_pos)
	if equipped_weapon and distance_to_target > equipped_weapon.distance_reach:
		var direction_to_target = self.global_position.direction_to(target_pos).normalized()
		look_direction = direction_to_target
		is_attacking = true
	else:
		look_direction = Vector2.ZERO
		is_attacking = false


func reset_attack():
	look_direction = Vector2.ZERO
	is_attacking = false


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

func _on_EnemyDetector_area_entered(area):
	if area.is_in_group("enemy_hurtbox"):
		nearest_enemies.append(area)

func _on_EnemyDetector_area_exited(area):
	if area.is_in_group("enemy_hurtbox"):
		nearest_enemies.remove(nearest_enemies.find(area))


func _on_DualButtonDetector_area_entered(area):
	if area.is_in_group("dual_button"):
		dual_button = area


func _on_DualButtonDetector_area_exited(area):
	if area.is_in_group("dual_button"):
		dual_button = null
