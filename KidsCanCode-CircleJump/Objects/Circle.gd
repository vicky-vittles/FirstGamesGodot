extends Area2D

enum MODES {STATIC, LIMITED}

const IMAGE_RADIUS = 143

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite
onready var beep = $Beep
onready var animation_player = $AnimationPlayer
onready var pivot = $Pivot
onready var move_tween = $MoveTween
onready var orbit_position = $Pivot/OrbitPosition
onready var orbit_label = $Label

var color

export (int) var radius = 100
export (int) var move_range = 0
export (float) var move_speed = 1.0
var jumper = null
var rotation_speed : float = PI
var mode = MODES.STATIC
var orbits : int = 3
var current_orbits : int = 0
var orbit_start : float

func init(_position, level):
	var _mode = Settings.rand_weighted([10, level-1])
	var move_chance = clamp(level-10, 0, 9) / 10.0
	if randf() < move_chance:
		move_range = max(25, 100 * rand_range(0.75, 1.25) * move_chance) * pow(-1, randi() % 2)
		move_speed = max(2.5 - ceil(level/5) * 0.25, 0.75)
		
	var small_chance = min(0.9, max(0, (level-10) / 20.0))
	if randf() < small_chance:
		radius = max(50, radius - level * rand_range(0.75, 1.25))
	
	position = _position
	set_mode(_mode)
	
	sprite.material = sprite.material.duplicate()
	
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.radius = radius
	
	sprite.scale = Vector2(1, 1) * radius / IMAGE_RADIUS
	
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1, randi() % 2)
	
	set_tween()

func set_mode(_mode):
	mode = _mode
	match mode:
		MODES.STATIC:
			color = Settings.theme["circle_static"]
			orbit_label.hide()
		MODES.LIMITED:
			color = Settings.theme["circle_limited"]
			current_orbits = orbits
			orbit_label.text = str(current_orbits)
			orbit_label.show()
			orbit_start = pivot.rotation
	
	sprite.material.set_shader_param("color", color)

func implode():
	animation_player.play("implode")
	yield(animation_player, "animation_finished")
	queue_free()

func capture(target):
	jumper = target
	pivot.rotation = (jumper.position - position).angle()
	orbit_start = pivot.rotation

func check_orbits():
	if abs(pivot.rotation - orbit_start) > 2*PI:
		current_orbits -= 1
		orbit_label.text = str(current_orbits)
		if Settings.enable_sound:
			beep.play()
		
		if current_orbits <= 0:
			jumper.die()
			jumper = null
			implode()
		orbit_start = pivot.rotation

func set_tween(object = null, key = null):
	if move_range == 0:
		return
	
	move_range *= -1
	move_tween.interpolate_property(self, "position:x", position.x, 
						position.x+move_range, move_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	move_tween.start()

func _process(delta):
	pivot.rotate(rotation_speed*delta)
	
	if mode == MODES.LIMITED and jumper:
		check_orbits()
