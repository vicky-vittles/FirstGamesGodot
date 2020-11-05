extends "res://Entities/Enemies/Enemy.gd"

class_name Bub

var GRAVITY = 624
var fsm : StateMachine

#var stompable = false
#var attackable = false

func _ready():
	fsm = $StateMachine
#	if get_node_or_null("Stompable") != null:
#		stompable = true
#
#	if get_node_or_null("Attackable") != null:
#		attackable = true

func disable_shapes():
	$CollisionShape2D.set_deferred("disabled", true)
	$ContactAttack.disable_shapes()

func die():
	queue_free()
