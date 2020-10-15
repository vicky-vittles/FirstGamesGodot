extends State

const TILE_SIZE = 16
const KNOCKBACK_DISTANCE = 2 * TILE_SIZE
const KNOCKBACK_TIME = 0.7
const KNOCKBACK_ACCELERATION = -2*KNOCKBACK_DISTANCE / (KNOCKBACK_TIME * KNOCKBACK_TIME)
const KNOCKBACK_INITIAL_VELOCITY = 2*KNOCKBACK_DISTANCE / KNOCKBACK_TIME

func _ready():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")

func enter():
	fsm.actor.velocity = Vector2(KNOCKBACK_INITIAL_VELOCITY * sign(fsm.actor.hit_direction.x), 0)

func exit():
	pass

func physics_process(delta):
	
	var hit_sign = sign(fsm.actor.hit_direction.x)
	
	if hit_sign == 1:
		fsm.actor.velocity.x = clamp(fsm.actor.velocity.x + KNOCKBACK_ACCELERATION * hit_sign * delta, 0, KNOCKBACK_INITIAL_VELOCITY)
	elif hit_sign == -1:
		fsm.actor.velocity.x = clamp(fsm.actor.velocity.x + KNOCKBACK_ACCELERATION * hit_sign * delta, -KNOCKBACK_INITIAL_VELOCITY, 0)
	
	fsm.actor.velocity = fsm.actor.move_and_slide(fsm.actor.velocity)
	
	if fsm.actor.velocity == Vector2.ZERO:
		if $"../BasicEnemyRun".marked_player == null:
			fsm.change_state($"../BasicEnemyIdle")
		else:
			fsm.change_state($"../BasicEnemyRun")

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_attack") and fsm.current_state == self:
		var enemy_pos
		
		if (area is Weapon):
			enemy_pos = (area as Weapon).global_position
		
		elif (area is Projectile):
			enemy_pos = (area as Projectile).global_position
		
		fsm.actor.hit_direction = (fsm.actor.global_position - enemy_pos).normalized()
		fsm.change_state($"../KnockbackHurt")
