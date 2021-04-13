extends Node2D

onready var hero = get_parent()
onready var main_sprite = $Main
onready var hand = $Hand
onready var gun_dummy = hand.get_node("GunDummy")
onready var animation_player = $AnimationPlayer

var hero_color : int

func _ready():
	var hero_id = int(hero.name)
	hero_color = Network.players.find(hero_id)%HeroDB.HERO_COLOURS.size()
	main_sprite.texture = HeroDB.HERO_SPRITES[hero_color]

func _physics_process(delta):
	if not is_network_master():
		animation_player.stop()
		if hand.has_node("Gun"):
			var gun = hand.get_node("Gun")
			gun.visible = false

func update_info(info):
	# Main sprite
	main_sprite.frame = info["hero_sprite"]
	main_sprite.global_position = info["hero_sprite_pos"]
	main_sprite.scale.x = info["hero_sprite_dir"]
	
	# Gun
	gun_dummy.visible = info["hero_has_gun"]
	if info["hero_has_gun"]:
		gun_dummy.global_position = info["gun_pos"]
		gun_dummy.frame = info["gun_sprite"]
		gun_dummy.scale.x = info["gun_sprite_dir"]

func facing(dir: int):
	if dir == 1:
		scale.x = 1
	elif dir == -1:
		scale.x = -1

func play_anim(anim_name):
	animation_player.play(anim_name)

func stop_anim():
	animation_player.stop()
