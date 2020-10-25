extends State

const TILE_SIZE = 16
const KNOCKBACK_DISTANCE = 2 * TILE_SIZE
const KNOCKBACK_TIME = 0.7
const KNOCKBACK_ACCELERATION = -2*KNOCKBACK_DISTANCE / (KNOCKBACK_TIME * KNOCKBACK_TIME)
const KNOCKBACK_INITIAL_VELOCITY = 2*KNOCKBACK_DISTANCE / KNOCKBACK_TIME

var hit_direction

func _ready():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")

func enter():
	fsm.actor.get_node("AnimationPlayer").play("hurt")
	
	hit_direction = Vector2(sign(fsm.actor.hit_direction.x), sign(fsm.actor.hit_direction.y))
	fsm.actor.velocity = KNOCKBACK_INITIAL_VELOCITY * hit_direction

func exit():
	pass

func physics_process(delta):
	
	if hit_direction.x != 0:
		var hit_sign = sign(hit_direction.x)
		
		if hit_sign == 1:
			fsm.actor.velocity.x = clamp(fsm.actor.velocity.x + KNOCKBACK_ACCELERATION * hit_sign * delta, 0, KNOCKBACK_INITIAL_VELOCITY)
		elif hit_sign == -1:
			fsm.actor.velocity.x = clamp(fsm.actor.velocity.x + KNOCKBACK_ACCELERATION * hit_sign * delta, -KNOCKBACK_INITIAL_VELOCITY, 0)
		
	if hit_direction.y != 0:
		var hit_sign = sign(hit_direction.y)
		
		if hit_sign == 1:
			fsm.actor.velocity.y = clamp(fsm.actor.velocity.y + KNOCKBACK_ACCELERATION * hit_sign * delta, 0, KNOCKBACK_INITIAL_VELOCITY)
		elif hit_sign == -1:
			fsm.actor.velocity.y = clamp(fsm.actor.velocity.y + KNOCKBACK_ACCELERATION * hit_sign * delta, -KNOCKBACK_INITIAL_VELOCITY, 0)
	
	fsm.actor.velocity = fsm.actor.move_and_slide(fsm.actor.velocity)
	
	if fsm.actor.velocity == Vector2.ZERO:
		if fsm.actor.nearest_player == null:
			fsm.change_state($"../Idle")
		else:
			fsm.change_state($"../Run")

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_attack") and fsm.current_state == self:
		var hit_direction = Vector2()
		
		if (area is Weapon):
			hit_direction = (area as Weapon).direction
		
		elif (area is Projectile):
			hit_direction = (area as Projectile).direction
		
		fsm.actor.hit_direction = hit_direction.normalized()
		fsm.change_state($"../Hurt")
