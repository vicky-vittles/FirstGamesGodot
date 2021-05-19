extends Node

const MUSIC = preload("res://main/music.tscn")
const PLAYER_SIZE : int = 64

const PLAYER_COLOR : int = 0
const TURRET_WEAK_COLOR : int = 1
const TURRET_STRONG_COLOR : int = 2

const PALETTES = {
	0: [
		Color("5B6CF9"),
		Color("D291DF"),
		Color("EA98DA")
	],
	1: [
		Color("FF004D"),
		Color("1D2B53"),
		Color("29ADFF")
	],
	2: [
		Color("26C5F3"),
		Color("9C43F8"),
		Color("B429F9")
	],
	3: [
		Color("A8F368"),
		Color("EC2B60"),
		Color("F9035E")
	]}
var current_palette
var music_player

func _ready():
	choose_random_palette()
	pause_mode = Node.PAUSE_MODE_PROCESS
	music_player = MUSIC.instance()
	add_child(music_player)

func play_music():
	music_player.play()

func choose_random_palette():
	randomize()
	var max_size = PALETTES.size()
	var index = randi() % max_size
	current_palette = PALETTES[index]
