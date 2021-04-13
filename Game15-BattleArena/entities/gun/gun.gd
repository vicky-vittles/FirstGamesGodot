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
		graphics.play_anim(Strings.GUN_SHOOT)
		
		var bullet_info = {
			"pos": global_position + 15*Vector2(sign(dir.x), 0),
			"damage": gun_data.bullet_damage,
			"exceptions": exceptions,
			"dir": dir,
			"gun_type": gun_type}
		rpc("spawn_bullet", bullet_info)
		
		fire_rate_timer.start()

remotesync func spawn_bullet(bullet_info):
	var new_bullet = GunDB.get_bullet_type(bullet_info["gun_type"]).instance()
	get_tree().root.add_child(new_bullet)
	new_bullet.global_position = bullet_info["pos"]
	new_bullet.damage = bullet_info["damage"]
	new_bullet.exceptions = bullet_info["exceptions"]
	new_bullet.fire(bullet_info["dir"])
