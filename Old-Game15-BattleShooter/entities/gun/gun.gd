extends Node2D

signal gun_reloaded()
signal out_of_ammo()

export (PackedScene) var BULLET
export (Texture) var cursor

export (float) var fire_rate = 0.25
export (int) var initial_ammo = 10
export (int) var bullets_fired = 1
export (float) var spacing_between_bullets = 0

onready var ammo : int = initial_ammo

onready var fire_rate_timer = $FireRateTimer
onready var animation_player = $AnimationPlayer

func _ready():
	fire_rate_timer.wait_time = fire_rate
	equip()

func equip():
	Input.set_custom_mouse_cursor(cursor)

func fire(dir: Vector2, exception):
	if not fire_rate_timer.is_stopped() or ammo <= 0:
		return
	var current_angle = -int(bullets_fired/2)*spacing_between_bullets
	for i in bullets_fired:
		var bullet = BULLET.instance()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		bullet.exceptions.append(exception)
		bullet.fire(dir.rotated(deg2rad(current_angle)))
		current_angle += spacing_between_bullets
	
	ammo -= 1
	if ammo <= 0:
		emit_signal("out_of_ammo")
	fire_rate_timer.start()

func play_look(anim_name: String):
	animation_player.play(anim_name)
