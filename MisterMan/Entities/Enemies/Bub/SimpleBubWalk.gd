extends Node

const TILE_SIZE = 16
const FLOOR_NORMAL = Vector2(0, -1)

enum InitialDirection {LEFT = -1, RIGHT = 1}
export (InitialDirection) var direction

export (float) var WALK_SPEED_IN_TILES = 2.5
var WALK_SPEED = WALK_SPEED_IN_TILES * TILE_SIZE

var animated_sprite
var health
var floor_raycast
var velocity = Vector2()
var fsm : StateMachine


func _ready():
	animated_sprite = $"../../AnimatedSprite"
	floor_raycast = $"../../FloorRaycast"
	health = $"../../Health"
	
	health.connect("has_died", self, "_on_Bub_death")
	health.connect("defended_hit", self, "_on_Player_defended_hit")
	
	if direction == 1:
		floor_raycast.position.x *= -1

func enter():
	pass

func exit(next_state):
	fsm.change_state(next_state)


func physics_process(delta):
	
	if direction == 1:
		animated_sprite.flip_h = true
	elif direction == -1:
		animated_sprite.flip_h = false
	
	velocity.x = WALK_SPEED * direction
	animated_sprite.play("walk")
	
	velocity.y += fsm.actor.GRAVITY * delta
	
	velocity = fsm.actor.move_and_slide(velocity, FLOOR_NORMAL)
	
	if fsm.actor.is_on_wall() or not floor_raycast.is_colliding():
		direction *= -1
		floor_raycast.position.x *= -1

func deactivate():
	exit($"../Idle")

func _on_Bub_death(hit, direction):
	if hit.team == "player_attack":
		exit($"../Dead")
		$"../Dead".hit_direction = direction
	elif hit.team == "player_stomp":
		exit($"../Squashed")

func _on_Player_defended_hit(hit, direction):
	exit($"../Protected")
