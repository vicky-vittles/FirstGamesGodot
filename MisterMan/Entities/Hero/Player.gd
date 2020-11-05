extends KinematicBody2D

class_name Hero

signal player_died()
signal update_health(new_amount)

export (NodePath) var timerPath
var debugTimer

const TILE_SIZE = 16
const CHAR_WIDTH = 10
const CHAR_HEIGHT = 13
const ONE_FRAME = 0.0166
const FLOOR_NORMAL = Vector2(0, -1)

const WALK_DISTANCE_COVERED_IN_ONE_SECOND = TILE_SIZE * 5
const RUN_DISTANCE_COVERED_IN_ONE_SECOND = TILE_SIZE * 11.5
const HURT_KNOCKBACK_DISTANCE_COVERED_IN_ONE_SECOND = TILE_SIZE * 2
const HURT_KNOCKBACK_HEIGHT_COVERED_IN_ONE_SECOND = TILE_SIZE * 4
var HURT_KNOCKBACK_TIME_DURATION

const WALK_SPEED = WALK_DISTANCE_COVERED_IN_ONE_SECOND
const RUN_SPEED = RUN_DISTANCE_COVERED_IN_ONE_SECOND
var HURT_KNOCKBACK_DISTANCE_SPEED
var HURT_KNOCKBACK_HEIGHT_SPEED

const TIME_TO_WALK_SPEED = ONE_FRAME * 6
const TIME_FROM_WALK_TO_ZERO_SPEED = ONE_FRAME * 3
const TIME_TO_RUN_SPEED = ONE_FRAME * 60
const TIME_FROM_RUN_TO_ZERO_SPEED = ONE_FRAME * 40
const WALK_ACC = WALK_SPEED / TIME_TO_WALK_SPEED
const WALK_DEACC = WALK_SPEED / TIME_FROM_WALK_TO_ZERO_SPEED
const RUN_ACC = RUN_SPEED / TIME_TO_RUN_SPEED
const RUN_DEACC = RUN_SPEED / TIME_FROM_RUN_TO_ZERO_SPEED

const JUMP_HEIGHT_WHILE_WALK = 4 * CHAR_HEIGHT
const JUMP_ASCENT_TIME_WHILE_WALK = ONE_FRAME * 25
const JUMP_ASCENT_GRAVITY_WHILE_WALK = 2 * JUMP_HEIGHT_WHILE_WALK / (JUMP_ASCENT_TIME_WHILE_WALK * JUMP_ASCENT_TIME_WHILE_WALK)
const JUMP_ASCENT_SPEED_WHILE_WALK = -2 * JUMP_HEIGHT_WHILE_WALK / JUMP_ASCENT_TIME_WHILE_WALK
const JUMP_DESCENT_TIME_WHILE_WALK = ONE_FRAME * 19
const JUMP_DESCENT_GRAVITY_WHILE_WALK = 2 * JUMP_HEIGHT_WHILE_WALK / (JUMP_DESCENT_TIME_WHILE_WALK * JUMP_DESCENT_TIME_WHILE_WALK)
const JUMP_DESCENT_SPEED_WHILE_WALK = -2 * JUMP_HEIGHT_WHILE_WALK / JUMP_DESCENT_TIME_WHILE_WALK

var jump_height_dynamic
var jump_ascent_time_dynamic
var jump_ascent_gravity_dynamic
var jump_ascent_speed_dynamic
var jump_descent_time_dynamic
var jump_descent_gravity_dynamic
var jump_descent_speed_dynamic

const JUMP_HEIGHT_WHILE_RUN = 6 * CHAR_HEIGHT
const JUMP_ASCENT_TIME_WHILE_RUN = ONE_FRAME * 34
#const JUMP_ASCENT_GRAVITY_WHILE_RUN = 2 * JUMP_HEIGHT_WHILE_RUN / (JUMP_ASCENT_TIME_WHILE_RUN * JUMP_ASCENT_TIME_WHILE_RUN)
#const JUMP_ASCENT_SPEED_WHILE_RUN = -2 * JUMP_HEIGHT_WHILE_RUN / JUMP_ASCENT_TIME_WHILE_RUN
const JUMP_DESCENT_TIME_WHILE_RUN = ONE_FRAME * 26
#const JUMP_DESCENT_GRAVITY_WHILE_RUN = 2 * JUMP_HEIGHT_WHILE_RUN / (JUMP_DESCENT_TIME_WHILE_RUN * JUMP_DESCENT_TIME_WHILE_RUN)
#const JUMP_DESCENT_SPEED_WHILE_RUN = -2 * JUMP_HEIGHT_WHILE_RUN / JUMP_DESCENT_TIME_WHILE_RUN

const STOMP_HEIGHT = 3 * CHAR_HEIGHT
const STOMP_TIME = ONE_FRAME * 15
const STOMP_GRAVITY = 2 * STOMP_HEIGHT / (STOMP_TIME * STOMP_TIME)
const STOMP_SPEED = -2 * STOMP_HEIGHT / STOMP_TIME

const AIR_FRICTION_TIME = ONE_FRAME / 2
const AIR_FRICTION = WALK_SPEED / AIR_FRICTION_TIME

enum STATES {IDLE, WALK, RUN, JUMP, FALL, ATTACK, HURT, DEAD}
enum DAMAGE_STATES {VULNERABLE, INVINCIBLE}
const ANIMATION_STATES = ["idle", "walk", "run", "jump", "fall", "attack", "hurt", "hurt"]
var current_state
var last_move_state
var current_damage_state

var max_health = 3
var health = max_health

var PUNCH_SMEAR = preload("res://Entities/Hero/PunchSmear.tscn")

var is_alive = true
var has_stomped = false
var took_damage = false
var is_attack_finished = false
var is_kick_finished = false
var disable_inputs = false

var run_smear_timeout = false
var jump_walk_hang_timeout = false
var jump_run_hang_timeout = false
var knockback_timeout = false
var iframes_timeout = false

var right = false
var left = false
var jump = false
var attack = false
var pressing_attack = false

var direction = 1
var last_direction = 1
var hit_direction = Vector2()
var velocity = Vector2()
var acceleration = Vector2(0, JUMP_ASCENT_GRAVITY_WHILE_WALK)


func _ready():
	change_state(STATES.IDLE)
	last_move_state = STATES.WALK
	change_damage_state(DAMAGE_STATES.VULNERABLE)
	
	calculate_dynamic_jump(RUN_SPEED)
	debugTimer = get_node(timerPath)
	#print(ceil(60*WALK_SPEED / RUN_ACC))
	
	HURT_KNOCKBACK_TIME_DURATION = $Timers/KnockbackTimer.wait_time
	HURT_KNOCKBACK_DISTANCE_SPEED = HURT_KNOCKBACK_DISTANCE_COVERED_IN_ONE_SECOND / HURT_KNOCKBACK_TIME_DURATION
	HURT_KNOCKBACK_HEIGHT_SPEED = HURT_KNOCKBACK_HEIGHT_COVERED_IN_ONE_SECOND / HURT_KNOCKBACK_TIME_DURATION
	
	$StompHitbox.hit.team = "player_stomp"
	
	$StompHitbox.connect("hit_landed", self, "_on_StompHitbox_hit_landed")
	$Hurtbox.connect("hit_landed", self, "get_hurt")
	$"../Coins/Coin9".connect("body_entered", self, "got_coin")


func _physics_process(delta):
	
	if debugTimer is Timer:
		if debugTimer.is_stopped():
			$TextureProgress.value = 0
		else:
			$TextureProgress.value = 100 * (debugTimer.wait_time - debugTimer.time_left) / debugTimer.wait_time
		$Label.text = str(debugTimer.get_path().get_name(4)) + "\n" + str(debugTimer.is_stopped()) + "\n" + str(debugTimer.time_left)
	
	if not disable_inputs:
		right = Input.is_action_pressed("right")
		left = Input.is_action_pressed("left")
		jump = Input.is_action_just_pressed("jump")
		attack = Input.is_action_just_pressed("attack")
		pressing_attack = Input.is_action_pressed("attack")
	else:
		right = false
		left = false
		jump = false
		attack = false
		pressing_attack = false
		
	if right and left:
		right = false
		left = false
	
	if right:
		direction = 1
		last_direction = 1
	elif left:
		direction = -1
		last_direction = -1
	
	if sign($AttackSpawn.position.x) != direction:
		$AttackSpawn.position.x *= -1
	
	match current_damage_state:
		DAMAGE_STATES.VULNERABLE:
			damage_vulnerable(delta)
		DAMAGE_STATES.INVINCIBLE:
			damage_invincible(delta)
	
	match current_state:
		STATES.IDLE:
			idle(delta)
		STATES.WALK:
			walk(delta)
		STATES.RUN:
			run(delta)
		STATES.JUMP:
			jump(delta)
		STATES.FALL:
			fall(delta)
		STATES.ATTACK:
			attack(delta)
		STATES.HURT:
			hurt(delta)
		STATES.DEAD:
			dead(delta)
	
	if not right and not left:
		
		var is_in_air = current_state == STATES.JUMP or current_state == STATES.FALL
		
		if velocity.x > 0:
			if is_in_air:
				if last_move_state == STATES.WALK:
					velocity.x = clamp(velocity.x - AIR_FRICTION * delta, 0, WALK_SPEED)
				elif last_move_state == STATES.RUN:
					velocity.x = clamp(velocity.x - AIR_FRICTION * delta, 0, RUN_SPEED)
			else:
				if last_move_state == STATES.WALK:
					velocity.x = clamp(velocity.x - WALK_DEACC * delta, 0, WALK_SPEED)
				elif last_move_state == STATES.RUN:
					velocity.x = clamp(velocity.x - RUN_DEACC * delta, 0, RUN_SPEED)
				
		elif velocity.x < 0:
			if is_in_air:
				if last_move_state == STATES.WALK:
					velocity.x = clamp(velocity.x + AIR_FRICTION * delta, -WALK_SPEED, 0)
				elif last_move_state == STATES.RUN:
					velocity.x = clamp(velocity.x + AIR_FRICTION * delta, -RUN_SPEED, 0)
			else:
				if last_move_state == STATES.WALK:
					velocity.x = clamp(velocity.x + WALK_DEACC * delta, -WALK_SPEED, 0)
				elif last_move_state == STATES.RUN:
					velocity.x = clamp(velocity.x + RUN_DEACC * delta, -RUN_SPEED, 0)
				
	else:
		
		var min_clamp
		var max_clamp
		
		if last_move_state == STATES.RUN:
			acceleration.x = RUN_ACC
			min_clamp = -RUN_SPEED
			max_clamp = RUN_SPEED
			
		elif last_move_state == STATES.WALK:
			acceleration.x = WALK_ACC
			min_clamp = -WALK_SPEED
			max_clamp = WALK_SPEED
		
		if right:
			$AnimatedSprite.flip_h = false
			velocity.x = clamp(velocity.x + acceleration.x * delta, min_clamp, max_clamp)
		elif left:
			$AnimatedSprite.flip_h = true
			velocity.x = clamp(velocity.x - acceleration.x * delta, min_clamp, max_clamp)
	
	if current_state == STATES.ATTACK:
		velocity.x = 0
	elif current_state == STATES.HURT:
		velocity.x = HURT_KNOCKBACK_DISTANCE_SPEED * hit_direction.x
	
	velocity.y += acceleration.y * delta
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	#velocity = move_and_slide(velocity, FLOOR_NORMAL, false, 4, 0.785398, false)


func idle(delta):
	
	if took_damage:
		change_state(STATES.HURT)
		took_damage = false
		
	elif attack:
		change_state(STATES.ATTACK)
		is_attack_finished = false
		$PunchSFX.play()
		
		var punch = PUNCH_SMEAR.instance()
		punch.position = $AttackSpawn.global_position
		punch.activate(direction)
		$"../Hitboxes".add_child(punch)
		
	elif is_on_floor() and jump:
		change_state(STATES.JUMP)
		last_move_state = STATES.WALK
		velocity.y = JUMP_ASCENT_SPEED_WHILE_WALK
		acceleration.y = JUMP_ASCENT_GRAVITY_WHILE_WALK
		$JumpSFX.play()
		
	elif right or left:
		change_state(STATES.WALK)
		last_move_state = STATES.WALK


func walk(delta):
	
	if took_damage:
		change_state(STATES.HURT)
		took_damage = false
		
	elif not is_on_floor():
		change_state(STATES.FALL)
		$Timers/CoyoteJumpTimer.start()
		acceleration.y = JUMP_ASCENT_GRAVITY_WHILE_WALK
		
	elif attack:
		change_state(STATES.ATTACK)
		is_attack_finished = false
		$PunchSFX.play()
		
		var punch = PUNCH_SMEAR.instance()
		punch.position = $AttackSpawn.global_position
		punch.activate(direction)
		$"../Hitboxes".add_child(punch)
		
	elif is_on_floor() and jump:
		change_state(STATES.JUMP)
		last_move_state = STATES.WALK
		velocity.y = JUMP_ASCENT_SPEED_WHILE_WALK
		acceleration.y = JUMP_ASCENT_GRAVITY_WHILE_WALK
		$JumpSFX.play()
		
	elif not right and not left:
		change_state(STATES.IDLE)
		last_move_state = STATES.WALK


func run(delta):
	
	$AnimatedSprite.play(ANIMATION_STATES[STATES.RUN])
	
	var anim_speed = 10 + 15*(abs(velocity.x) / RUN_SPEED)
	$AnimatedSprite.frames.set_animation_speed(ANIMATION_STATES[STATES.RUN], anim_speed)
	
	if right or left:
		$Timers/RunSmearTimer.stop()
	
	if took_damage:
		change_state(STATES.HURT)
		took_damage = false
		
	elif not is_on_floor():
		change_state(STATES.FALL)
		$Timers/CoyoteJumpTimer.start()
		acceleration.y = jump_ascent_gravity_dynamic
		
	elif is_on_floor() and jump:
		change_state(STATES.JUMP)
		last_move_state = STATES.RUN
		calculate_dynamic_jump(velocity.x)
		velocity.y = jump_ascent_speed_dynamic
		acceleration.y = jump_ascent_gravity_dynamic
		$JumpSFX.play()
		
	elif not pressing_attack and (right or left):
		change_state(STATES.WALK)
		last_move_state = STATES.WALK
		
	elif not right and not left:
		$AnimatedSprite.play(ANIMATION_STATES[STATES.IDLE])
		if $Timers/RunSmearTimer.is_stopped():
			$Timers/RunSmearTimer.start()
		elif run_smear_timeout:
			$Timers/RunSmearTimer.stop()
			run_smear_timeout = false
			last_move_state = STATES.WALK
			change_state(STATES.IDLE)


func jump(delta):
	
	if took_damage:
		change_state(STATES.HURT)
		took_damage = false
		
	elif velocity.y >= 0:
		
		velocity.y = 0
		acceleration.y = 0
		
		if last_move_state == STATES.WALK:
			if $Timers/JumpWalkHangTimer.is_stopped() and not jump_walk_hang_timeout:
				$Timers/JumpWalkHangTimer.start()
			
			if jump_walk_hang_timeout:
				jump_walk_hang_timeout = false
				change_state(STATES.FALL)
				acceleration.y = JUMP_DESCENT_GRAVITY_WHILE_WALK
			
		elif last_move_state == STATES.RUN:
			if $Timers/JumpRunHangTimer.is_stopped() and not jump_run_hang_timeout:
				$Timers/JumpRunHangTimer.start()
			
			if jump_run_hang_timeout:
				jump_run_hang_timeout = false
				change_state(STATES.FALL)
				acceleration.y = jump_descent_gravity_dynamic


func fall(delta):
	
	if jump and $Timers/JumpPressTimer.is_stopped():
		$Timers/JumpPressTimer.start()
	
	if not is_alive:
		change_state(STATES.DEAD)
		
		$"StompHitbox/CollisionShape2D".set_deferred("disabled", true)
		$PhysicsShape.set_deferred("disabled", true)
		velocity.y = JUMP_ASCENT_SPEED_WHILE_WALK
		acceleration.y = JUMP_ASCENT_GRAVITY_WHILE_WALK
		
	elif took_damage:
		change_state(STATES.HURT)
		took_damage = false
		
	elif has_stomped:
		has_stomped = false
		change_state(STATES.JUMP)
		acceleration.y = STOMP_GRAVITY
		
	elif jump and (not $Timers/CoyoteJumpTimer.is_stopped() and $Timers/CoyoteJumpTimer.wait_time > 0):
		change_state(STATES.JUMP)
		if last_move_state == STATES.WALK:
			velocity.y = JUMP_ASCENT_SPEED_WHILE_WALK
			acceleration.y = JUMP_ASCENT_GRAVITY_WHILE_WALK
		elif last_move_state == STATES.RUN:
			velocity.y = jump_ascent_speed_dynamic
			acceleration.y = jump_ascent_gravity_dynamic
		$JumpSFX.play()
		
	elif is_on_floor():
		if $Timers/JumpPressTimer.wait_time > 0 and not $Timers/JumpPressTimer.is_stopped():
			change_state(STATES.JUMP)
			if last_move_state == STATES.WALK:
				velocity.y = JUMP_ASCENT_SPEED_WHILE_WALK
				acceleration.y = JUMP_ASCENT_GRAVITY_WHILE_WALK
			elif last_move_state == STATES.RUN:
				velocity.y = jump_ascent_speed_dynamic
				acceleration.y = jump_ascent_gravity_dynamic
			$JumpSFX.play()
			
		elif not right and not left:
			change_state(STATES.IDLE)
			
		elif right or left:
			if last_move_state == STATES.WALK:
				change_state(STATES.WALK)
			elif last_move_state == STATES.RUN:
				change_state(STATES.RUN)


func attack(delta):
	
#	elif attack:
#		$AnimatedSprite.frame = 0
#		is_attack_finished = false
#
#		var punch = PUNCH_SMEAR.instance()
#		punch.position = $AttackSpawn.global_position
#		punch.activate(direction)
#		$"../Hitboxes".add_child(punch)
	
	if took_damage:
		change_state(STATES.HURT)
		took_damage = false
		
	elif is_attack_finished:
		
		if not right and not left:
			last_move_state = STATES.WALK
			change_state(STATES.IDLE)
			
		elif right or left:
			
			if pressing_attack:
				last_move_state = STATES.RUN
				change_state(STATES.RUN)
			else:
				last_move_state = STATES.WALK
				change_state(STATES.WALK)


func hurt(delta):
	
	#x_speed = HURT_KNOCKBACK_DISTANCE_SPEED * hit_direction.x
	$StompHitbox.set_deferred("disabled", true)
	disable_inputs = true
	
	$Timers/IFramesTimer.start()
	
	if not knockback_timeout and $Timers/KnockbackTimer.is_stopped():
		$Timers/KnockbackTimer.start()
	
	if knockback_timeout:
		knockback_timeout = false
		disable_inputs = false
		
		if is_alive:
			$StompHitbox.set_deferred("disabled", false)
			
			if is_on_floor():
				if not right and not left:
					change_state(STATES.IDLE)
				elif right or left:
					change_state(STATES.WALK)
			else:
				change_state(STATES.FALL)
				acceleration.y = JUMP_ASCENT_GRAVITY_WHILE_WALK
		else:
			$"StompHitbox/CollisionShape2D".set_deferred("disabled", true)
			$PhysicsShape.set_deferred("disabled", true)
			velocity.y = JUMP_ASCENT_SPEED_WHILE_WALK
			acceleration.y = JUMP_ASCENT_GRAVITY_WHILE_WALK
			
			$AnimationEffects.stop(true)
			$Timers/IFramesTimer.stop()
			
			change_state(STATES.DEAD)


func dead(delta):
	disable_inputs = true
	if $Timers/DeathTimer.is_stopped():
		$Timers/DeathTimer.start()


func damage_vulnerable(delta):
	
	if not $Timers/IFramesTimer.is_stopped():
		change_damage_state(DAMAGE_STATES.INVINCIBLE)
		$"Hurtbox/CollisionShape2D".set_deferred("disabled", true)
		$AnimationEffects.play("iframes_invincible")


func damage_invincible(delta):
	
	if iframes_timeout:
		iframes_timeout = false
		
		change_damage_state(DAMAGE_STATES.VULNERABLE)
		$"Hurtbox/CollisionShape2D".set_deferred("disabled", false)


func change_state(new_state):
	current_state = new_state
	$AnimatedSprite.play(ANIMATION_STATES[new_state])


func change_damage_state(new_state):
	current_damage_state = new_state


func calculate_jump_gravity(jump_height, jump_time):
	return 2 * jump_height / (jump_time * jump_time)


func calculate_jump_speed(jump_height, jump_time):
	return -2 * jump_height / jump_time


func calculate_dynamic_jump(velocity):
	var t = (max(velocity, WALK_SPEED) - WALK_SPEED) / (RUN_SPEED - WALK_SPEED)
	
	jump_height_dynamic = JUMP_HEIGHT_WHILE_WALK + (JUMP_HEIGHT_WHILE_RUN - JUMP_HEIGHT_WHILE_WALK) * t
	
	jump_ascent_time_dynamic = JUMP_ASCENT_TIME_WHILE_WALK + (JUMP_ASCENT_TIME_WHILE_RUN - JUMP_ASCENT_TIME_WHILE_WALK) * t
	jump_ascent_gravity_dynamic = calculate_jump_gravity(jump_height_dynamic, jump_ascent_time_dynamic)
	jump_ascent_speed_dynamic = calculate_jump_speed(jump_height_dynamic, jump_ascent_time_dynamic)
	
	jump_descent_time_dynamic = JUMP_DESCENT_TIME_WHILE_WALK + (JUMP_DESCENT_TIME_WHILE_RUN - JUMP_DESCENT_TIME_WHILE_WALK) * t
	jump_descent_gravity_dynamic = calculate_jump_gravity(jump_height_dynamic, jump_ascent_time_dynamic)
	jump_descent_speed_dynamic = calculate_jump_speed(jump_height_dynamic, jump_ascent_time_dynamic)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == ANIMATION_STATES[STATES.ATTACK]:
		is_attack_finished = true


func _on_StompHitbox_hit_landed(area):
	if area.is_in_group("stompable"):
		velocity.y = STOMP_SPEED
		has_stomped = true


func _on_KnockbackTimer_timeout():
	knockback_timeout = true


func get_hurt(hit, direction):
	hit_direction = direction
	if hit.team == "enemy" and $Timers/IFramesTimer.is_stopped():
		took_damage = true
		velocity.y = -HURT_KNOCKBACK_HEIGHT_SPEED
		acceleration.y = JUMP_ASCENT_GRAVITY_WHILE_WALK
		
		update_health(health - hit.damage)
		if health <= 0:
			is_alive = false
			
	elif hit.team == "death_zone":
		
		update_health(health - hit.damage)
		if health <= 0:
			is_alive = false


func update_health(new_amount):
	health = new_amount
	emit_signal("update_health", health)


func _on_IFramesTimer_timeout():
	iframes_timeout = true


func _on_DeathTimer_timeout():
	$"/root/PlayerVariables".coins = 0
	emit_signal("player_died")


func got_coin():
	pass


func _on_JumpWalkHangTimer_timeout():
	jump_walk_hang_timeout = true


func _on_RunSmearTimer_timeout():
	run_smear_timeout = true


func _on_JumpRunHangTimer_timeout():
	jump_run_hang_timeout = true


func _on_BrickHitbox_hit_landed(area):
	if area.is_in_group("bricks"):
		velocity.y = 0
