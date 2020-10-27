extends Area2D

class_name Weapon

export (NodePath) var user_path
onready var user = get_node(user_path)

export (int) var damage = 1

export (int) var reach = 20
export (int) var angular_reach = 45

export (int) var distance_reach = 32
export (float) var attack_duration = 0.1
onready var speed = distance_reach / attack_duration

var direction = Vector2(1, 0)


func _ready():
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)

func _physics_process(delta):
	pass

func disable():
	$Sprite.visible = false
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)

func turn_around(direction):
	if direction == 1:
		$Sprite.flip_h = false
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
	elif direction == -1:
		$Sprite.flip_h = true
		$CollisionShape2D.position.x = -1 * abs($CollisionShape2D.position.x)
