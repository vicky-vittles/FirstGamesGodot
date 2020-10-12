extends Area2D

class_name Weapon

export (NodePath) var player_path
onready var player = get_node(player_path)

export (int) var reach = 20
export (int) var angular_reach = 45

var direction = Vector2(1, 0)


func _physics_process(delta):
	pass

func turn_around(direction):
	if direction == 1:
		$Sprite.flip_h = false
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
	elif direction == -1:
		$Sprite.flip_h = true
		$CollisionShape2D.position.x = -1 * abs($CollisionShape2D.position.x)
