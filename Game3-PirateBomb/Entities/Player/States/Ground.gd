extends State

var player
var ground_animation_finished = false

func enter():
	player = fsm.actor
	player.acceleration.y = Player.JUMP_ASCENT_GRAVITY
	player.animated_sprite.play("ground")

func process(delta):
	player.get_input()

func physics_process(delta):
	
	if player.attack:
		player.place_bomb()
	
	if player.right:
		player.velocity.x = Player.RUN_SPEED
		player.turn_around(1)
	elif player.left:
		player.velocity.x = -Player.RUN_SPEED
		player.turn_around(-1)
	else:
		player.velocity.x = 0
	
	if player.jump or ($"../Fall/JumpPressTimer".time_left > 0 and not $"../Fall/JumpPressTimer".is_stopped()):
		fsm.change_state($"../Jump")
	elif ground_animation_finished:
		
		ground_animation_finished = false
		
		if player.jump:
			fsm.change_state($"../Jump")
		elif player.right or player.left:
			fsm.change_state($"../Run")
		else:
			fsm.change_state($"../Idle")
	
	player.velocity = player.move_and_slide(player.velocity)

func _on_AnimatedSprite_animation_finished():
	if fsm.current_state == self and player.animated_sprite.animation == "ground":
		ground_animation_finished = true
