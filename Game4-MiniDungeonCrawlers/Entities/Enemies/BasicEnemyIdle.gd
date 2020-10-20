extends State

var wander_direction = 0

func _ready():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")

func enter():
	$AITimer.start()

func exit():
	pass

func physics_process(delta):
	
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
	randomize()
	wander_direction = pow(-1, randi() % 2)
	$WalkTimer.start()

func _on_WalkTimer_timeout():
	wander_direction = 0

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_attack") and fsm.current_state == self:
		var enemy_pos
		
		if (area is Weapon):
			enemy_pos = (area as Weapon).global_position
		
		elif (area is Projectile):
			enemy_pos = (area as Projectile).global_position
		
		fsm.actor.hit_direction = (fsm.actor.global_position - enemy_pos).normalized()
		fsm.change_state($"../Hurt")
