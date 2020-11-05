extends Node

const FLOOR_NORMAL = Vector2(0, -1)
const TILE_SIZE = 16
const KNOCKBACK_SPEED = Vector2( 2*TILE_SIZE, -10*TILE_SIZE )

var fsm : StateMachine
var animated_sprite
var hit_direction = 0
var velocity = Vector2()

func _ready():
	animated_sprite = $"../../AnimatedSprite"

func enter():
	fsm.actor.disable_shapes()
	velocity.y = KNOCKBACK_SPEED.y

func exit(next_state):
	fsm.change_state(next_state)

func physics_process(delta):
	animated_sprite.play("hurt")
	
	if not $"../../VisibilityNotifier2D".is_on_screen():
		fsm.actor.die()
		
	velocity.x = hit_direction.x * KNOCKBACK_SPEED.x
	velocity.y += fsm.actor.GRAVITY * delta
	
	velocity = fsm.actor.move_and_slide(velocity, FLOOR_NORMAL)
