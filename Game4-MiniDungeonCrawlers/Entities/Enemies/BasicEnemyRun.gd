extends State

func _ready():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")

func enter():
	pass

func exit():
	pass

func physics_process(_delta):
	
	fsm.actor.poll_input()
	
	if fsm.actor.nearest_player == null:
		fsm.change_state($"../Idle")
	
	else:
		fsm.actor.get_node("AnimationPlayer").play("run")
		
		var nearest_player_pos = fsm.actor.nearest_player.global_position
		var direction_to_player = (nearest_player_pos - fsm.actor.global_position).normalized()
		
		fsm.actor.turn_around(sign(direction_to_player.x))
		
		fsm.actor.velocity = fsm.actor.move_and_slide(direction_to_player * fsm.actor.SPEED)

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_attack") and fsm.current_state == self:
		var hit_direction = Vector2()
		
		if (area is Weapon):
			hit_direction = (area as Weapon).direction
		
		elif (area is Projectile):
			hit_direction = (area as Projectile).direction
		
		fsm.actor.hit_direction = hit_direction.normalized()
		fsm.change_state($"../Hurt")
