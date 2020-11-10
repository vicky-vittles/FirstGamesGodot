extends Area2D

enum MODES {STATIC, LIMITED}

onready var animation_player = $AnimationPlayer
onready var pivot = $Pivot
onready var orbit_position = $Pivot/OrbitPosition
onready var orbit_label = $Label

export (int) var radius = 100
var jumper = null
var rotation_speed : float = PI
var mode = MODES.STATIC
var orbits : int = 3
var current_orbits : int = 0
var orbit_start : float

func init(_position, _radius = radius, _mode = MODES.LIMITED):
	position = _position
	radius = _radius
	set_mode(_mode)
	
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / img_size
	
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1, randi() % 2)

func set_mode(_mode):
	mode = _mode
	match mode:
		MODES.STATIC:
			orbit_label.hide()
		MODES.LIMITED:
			current_orbits = orbits
			orbit_label.text = str(current_orbits)
			orbit_label.show()
			orbit_start = pivot.rotation

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
		if current_orbits <= 0:
			jumper.die()
			jumper = null
			implode()
		orbit_start = pivot.rotation

func _process(delta):
	pivot.rotate(rotation_speed*delta)
	
	if mode == MODES.LIMITED and jumper:
		check_orbits()
