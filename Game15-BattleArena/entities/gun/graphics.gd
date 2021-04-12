extends Node2D

const SHOOT_ANIMATION_TIME = 0.05
var shoot_intensity : int = 3

onready var body = $Body # Node used for following player using physics movement
onready var pivot = $Body/Pivot # Node used for auxiliary animations (shooting/reloading)
onready var main_sprite = $Body/Pivot/Main # The actual sprite
onready var tween = $Tween

func update_model(gun_type: int, gun_variation: int):
	var frame = GunDB.get_sprite(gun_type, gun_variation)
	var pos = GunDB.get_placement(gun_type, gun_variation)
	var intensity = GunDB.get_shoot_intensity(gun_type, gun_variation)
	main_sprite.frame = frame
	main_sprite.position = pos
	shoot_intensity = intensity

func _physics_process(delta):
	if not tween.is_active():
		pivot.position = Vector2.ZERO

func play_anim(anim_name):
	match anim_name:
		Strings.GUN_SHOOT:
			if not tween.is_active():
				tween.interpolate_property(pivot, "position:x", 0, 1*shoot_intensity, SHOOT_ANIMATION_TIME)
				tween.start()
		Strings.GUN_RELOAD:
			pass
