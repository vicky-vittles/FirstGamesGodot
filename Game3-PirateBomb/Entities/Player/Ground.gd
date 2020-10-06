extends State

var ground_animation_finished = false

func _ready():
	$"../../AnimatedSprite".connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

func enter():
	fsm.actor.acceleration.y = Player.JUMP_ASCENT_GRAVITY
	$"../../AnimatedSprite".play("ground")

func exit():
	pass

func physics_process(delta):
		
	var left = Input.is_action_pressed("left_" + str(fsm.actor.player_index))
	var right = Input.is_action_pressed("right_" + str(fsm.actor.player_index))
	var jump = Input.is_action_just_pressed("jump_" + str(fsm.actor.player_index))
	var attack = Input.is_action_just_pressed("bomb_" + str(fsm.actor.player_index))
	
	if left and right:
		left = false
		right = false
	
	if attack:
		fsm.actor.place_bomb()
	
	if right:
		fsm.actor.velocity.x = Player.RUN_SPEED
		fsm.actor.turn_around(1)
	elif left:
		fsm.actor.velocity.x = -Player.RUN_SPEED
		fsm.actor.turn_around(-1)
	else:
		fsm.actor.velocity.x = 0
	
	if jump or ($"../Fall/JumpPressTimer".time_left > 0 and not $"../Fall/JumpPressTimer".is_stopped()):
		fsm.change_state($"../Jump")
	elif ground_animation_finished:
		
		ground_animation_finished = false
		
		if jump:
			fsm.change_state($"../Jump")
		elif right or left:
			fsm.change_state($"../Run")
		else:
			fsm.change_state($"../Idle")
	
	fsm.actor.velocity = fsm.actor.move_and_slide(fsm.actor.velocity)

func _on_AnimatedSprite_animation_finished():
	if $"../../AnimatedSprite".animation == "ground" and fsm.current_state == self:
		ground_animation_finished = true
