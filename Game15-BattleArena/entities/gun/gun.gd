tool
extends Node2D

export (GunDB.GUN_TYPES) var gun_type = GunDB.GUN_TYPES.SMG
export (int, 1, 3) var gun_variation = 1

onready var gun_data = $GunData
onready var fire_rate_timer = $FireRateTimer
onready var graphics = $Graphics

func _ready():
	gun_data.load_data(gun_type, gun_variation)
	graphics.update_model(gun_type, gun_variation)
	fire_rate_timer.wait_time = gun_data.fire_rate

func shoot(dir: Vector2, exceptions: Array):
	if fire_rate_timer.is_stopped():
		var new_bullet = gun_data.BULLET.instance()
		get_tree().root.add_child(new_bullet)
		new_bullet.global_position = global_position
		new_bullet.damage = gun_data.bullet_damage
		new_bullet.exceptions = exceptions
		new_bullet.fire(dir)
		graphics.play_anim(Strings.GUN_SHOOT)
	
		fire_rate_timer.start()
