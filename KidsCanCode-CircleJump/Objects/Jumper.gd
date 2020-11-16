extends Area2D

signal captured(area)
signal die()

onready var sprite = $Sprite
onready var jump = $Jump
onready var capture = $Capture
onready var trail = $Trail/Points

var velocity = Vector2(100, 0)
var jump_speed : int = 1000
var target = null
var trail_length : int = 25
var is_alive : bool = true

func _ready():
	sprite.material.set_shader_param("color", Settings.theme["player_body"])
	var trail_color = Settings.theme["player_trail"]
	trail.gradient.set_color(1, trail_color)
	trail_color.a = 0
	trail.gradient.set_color(0, trail_color)


func _process(delta):
	if Input.is_action_just_pressed("jump"):
		jump()


func _physics_process(delta):
	
	if trail.points.size() > trail_length:
		trail.remove_point(0)
	trail.add_point(position)
	
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta

func jump():
	if Settings.enable_sound:
		jump.play()
	target.implode()
	target = null
	velocity = transform.x * jump_speed

func _on_Jumper_area_entered(area):
	target = area
	velocity = Vector2.ZERO
	emit_signal("captured", area)
	
	if Settings.enable_sound:
		capture.play()

func die():
	target = null
	is_alive = false
	emit_signal("die")
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	if !target and is_alive:
		die()
