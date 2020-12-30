extends State

var player
var hit_direction

func enter():
	player = fsm.actor
	player.velocity.y = Player.KNOCKBACK_SPEED.y
	player.acceleration.y = Player.KNOCKBACK_GRAVITY
	player.animated_sprite.play("hit")

func exit():
	player.velocity.x = 0

func physics_process(delta):
	
	player.velocity.x = sign(hit_direction.x) * Player.KNOCKBACK_SPEED.x
	
	player.move_y(delta)
	
	if player.is_on_floor():
		fsm.change_state($"../Idle")

func set_direction(direction):
	hit_direction = direction
