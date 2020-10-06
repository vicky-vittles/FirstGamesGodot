extends State

var hit_direction
var has_timeout = false

func enter():
	$HitTimer.start()
	fsm.actor.velocity.y = Player.KNOCKBACK_SPEED.y
	fsm.actor.acceleration.y = Player.KNOCKBACK_GRAVITY
	$"../../AnimatedSprite".play("dead_hit")

func exit():
	pass

func physics_process(delta):
	
	if fsm.actor.is_on_floor() and has_timeout:
		fsm.change_state($"../DeadGround")
	
	fsm.actor.velocity.x = sign(hit_direction.x) * Player.KNOCKBACK_SPEED.x
	
	fsm.actor.velocity.y += fsm.actor.acceleration.y * delta
	fsm.actor.velocity = fsm.actor.move_and_slide(fsm.actor.velocity, Vector2.UP)


func set_direction(direction):
	hit_direction = direction


func _on_HitTimer_timeout():
	has_timeout = true
