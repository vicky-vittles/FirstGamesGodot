extends State

var player
var hit_direction
var has_timeout = false

func enter():
	player = fsm.actor
	$HitTimer.start()
	player.velocity.y = Player.KNOCKBACK_SPEED.y
	player.acceleration.y = Player.KNOCKBACK_GRAVITY
	player.animated_sprite.play("dead_hit")

func physics_process(delta):
	
	if player.is_on_floor() and has_timeout:
		fsm.change_state($"../DeadGround")
	
	player.velocity.x = sign(hit_direction.x) * Player.KNOCKBACK_SPEED.x
	
	player.move_y(delta)


func set_direction(direction):
	hit_direction = direction


func _on_HitTimer_timeout():
	has_timeout = true
