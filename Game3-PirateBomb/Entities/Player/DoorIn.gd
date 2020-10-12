extends State

var has_entered_door = false
var direction
var door_pos
var door_animation_finished = false

func _ready():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")
	$"../../AnimatedSprite".connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

func enter():
	has_entered_door = false
	
	var player_pos = fsm.actor.global_position.x
	door_pos = fsm.actor.door.global_position.x
	
	if player_pos != door_pos:
		if player_pos < door_pos:
			fsm.actor.velocity.x = Player.RUN_SPEED
			direction = 1
			fsm.actor.turn_around(1)
			$"../../AnimatedSprite".play("run")
		else:
			fsm.actor.velocity.x = -Player.RUN_SPEED
			direction = -1
			fsm.actor.turn_around(-1)
			$"../../AnimatedSprite".play("run")
	else:
		$"../../AnimatedSprite".play("door_in")
		
	fsm.actor.acceleration.y = Player.JUMP_ASCENT_GRAVITY

func exit():
	pass

func physics_process(delta):
	
	if door_animation_finished:
		
		door_animation_finished = false
		
		fsm.change_state($"../DoorOut")
	
	else:
	
		var previous_pos = fsm.actor.global_position.x
		fsm.actor.velocity = fsm.actor.move_and_slide(fsm.actor.velocity, Vector2.UP)
		
		if direction == 1:
			fsm.actor.global_position.x = clamp(fsm.actor.global_position.x, previous_pos, door_pos)
		elif direction == -1:
			fsm.actor.global_position.x = clamp(fsm.actor.global_position.x, door_pos, previous_pos)
		
		if fsm.actor.global_position.x == previous_pos:
			if not has_entered_door:
				fsm.actor.door.enter()
			$"../../AnimatedSprite".play("door_in")
			has_entered_door = true
			fsm.actor.velocity.x = 0

func _on_AnimatedSprite_animation_finished():
	if $"../../AnimatedSprite".animation == "door_in" and fsm.current_state == self:
		door_animation_finished = true
		fsm.actor.global_position = fsm.actor.door.connected_door.get_node("PlayerTeleportPosition").global_position
		fsm.actor.door.connected_door.enter()
		fsm.actor.door.close()
		$"../DoorOut".door_to_exit = fsm.actor.door.connected_door


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("explosion") and fsm.current_state == self:
		var explosion = (area as Explosion)
		var hit_direction = (fsm.actor.global_position - explosion.global_position).normalized()
		
		$"../../Health".update_health(-area.hit.amount)
		
		if $"../../Health".health > 0:
			$"../Hurt".set_direction(hit_direction)
			fsm.change_state($"../Hurt")
		else:
			$"../DeadHit".set_direction(hit_direction)
			fsm.change_state($"../DeadHit")
