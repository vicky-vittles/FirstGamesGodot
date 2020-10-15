extends KinematicBody2D

const TILE_SIZE = 16
export (int) var HORIZONTAL_DISTANCE_IN_ONE_SECOND = 6
onready var SPEED = TILE_SIZE * HORIZONTAL_DISTANCE_IN_ONE_SECOND

var hit_direction = Vector2()
var velocity = Vector2()

func _ready():
	$Hurtbox.connect("area_entered", self, "_on_Hurtbox_area_entered")
	$Health.connect("die", self, "_on_Health_die")

func turn_around(direction):
	if direction == 1:
		$Sprite.flip_h = false
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
		$Hitbox.position.x = abs($Hitbox.position.x)
		$Hurtbox.position.x = abs($Hurtbox.position.x)
	elif direction == -1:
		$Sprite.flip_h = true
		$CollisionShape2D.position.x = -1 * abs($CollisionShape2D.position.x)
		$Hitbox.position.x = -1 * abs($Hitbox.position.x)
		$Hurtbox.position.x = -1 * abs($Hurtbox.position.x)

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_attack"):
		$Health.take_damage(area.damage)

func _on_Health_die():
	get_parent().remove_child(self)
	queue_free()
