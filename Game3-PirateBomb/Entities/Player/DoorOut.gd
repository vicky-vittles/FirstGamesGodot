extends State

var door_to_exit

var door_animation_finished = false

func _ready():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")
	$"../../AnimatedSprite".connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

func enter():
	$"../../AnimatedSprite".play("door_out")
	fsm.actor.acceleration.y = Player.JUMP_ASCENT_GRAVITY

func exit():
	pass

func physics_process(delta):
	
	if door_animation_finished:
		
		door_animation_finished = false
		
		fsm.change_state($"../Idle")

func _on_AnimatedSprite_animation_finished():
	if $"../../AnimatedSprite".animation == "door_out" and fsm.current_state == self:
		door_animation_finished = true
		door_to_exit.close()

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
