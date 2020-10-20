extends Area2D

class_name Weapon

export (NodePath) var player_path
onready var player = get_node(player_path)
onready var user = get_node(player_path)

export (int) var damage = 1

export (int) var reach = 20
export (int) var angular_reach = 45

export (int) var distance_reach = 32
export (float) var attack_duration = 0.1
onready var speed = distance_reach / attack_duration

var direction = Vector2(1, 0)


func _ready():
	$CollisionShape2D.set_deferred("disabled", true)

func _physics_process(delta):
	print($StateMachine.current_state.name)

func turn_around(direction):
	if direction == 1:
		$Sprite.flip_h = false
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
	elif direction == -1:
		$Sprite.flip_h = true
		$CollisionShape2D.position.x = -1 * abs($CollisionShape2D.position.x)
