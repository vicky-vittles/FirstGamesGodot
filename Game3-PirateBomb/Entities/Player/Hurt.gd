extends State

var hit_direction

func enter():
	fsm.actor.velocity.y = Player.KNOCKBACK_SPEED.y
	fsm.actor.acceleration.y = Player.KNOCKBACK_GRAVITY
	$"../../AnimatedSprite".play("hit")

func exit():
	fsm.actor.velocity.x = 0

func physics_process(delta):
	
	fsm.actor.velocity.x = sign(hit_direction.x) * Player.KNOCKBACK_SPEED.x
	
	fsm.actor.velocity.y += fsm.actor.acceleration.y * delta
	fsm.actor.velocity = fsm.actor.move_and_slide(fsm.actor.velocity, Vector2.UP)
	
	if fsm.actor.is_on_floor():
		fsm.change_state($"../Idle")

func set_direction(direction):
	hit_direction = direction
