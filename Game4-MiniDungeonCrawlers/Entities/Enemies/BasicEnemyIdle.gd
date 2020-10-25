extends State

var wander_direction = 0
var last_direction = 0

func _ready():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")

func enter():
	$AITimer.start()

func exit():
	wander_direction = 0
	last_direction = 0

func physics_process(delta):
	
	fsm.actor.poll_input()
	
	if fsm.actor.nearest_player != null:
		fsm.change_state($"../Run")
		
	else:
		if wander_direction == 0:
			fsm.actor.get_node("AnimationPlayer").play("idle")
			
		else:
			fsm.actor.get_node("AnimationPlayer").play("run")
		
			fsm.actor.turn_around(sign(wander_direction))
		
			fsm.actor.velocity = fsm.actor.move_and_slide(Vector2(sign(wander_direction), 0) * fsm.actor.SPEED)

func _on_AITimer_timeout():
	
	if last_direction == 0:
		randomize()
		wander_direction = pow(-1, randi() % 2)
		last_direction = wander_direction
	
	else:
		wander_direction = -1 * last_direction
		last_direction = wander_direction
	
	$WalkTimer.start()

func _on_WalkTimer_timeout():
	wander_direction = 0

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_attack") and fsm.current_state == self:
		var hit_direction = Vector2()
		
		if (area is Weapon):
			hit_direction = (area as Weapon).direction
		
		elif (area is Projectile):
			hit_direction = (area as Projectile).direction
		
		fsm.actor.hit_direction = hit_direction.normalized()
		fsm.change_state($"../Hurt")
