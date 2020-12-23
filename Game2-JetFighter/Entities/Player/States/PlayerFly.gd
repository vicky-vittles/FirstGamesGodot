extends State

var player

func enter():
	player = fsm.actor

func exit():
	pass

func process(delta):
	player.get_input()

func physics_process(delta):
	player.move(delta)
	
	if player.input_fire:
		player.fire()


func _on_Health_died():
	if fsm.current_state == self:
		fsm.change_state($"../Dead")


func _on_Player_game_won(player_victory):
	
	if player.player_index == player_victory:
		player.collision_polygon.set_deferred("disabled", true)
		player.hurtbox_polygon.set_deferred("disabled", true)
		
		fsm.change_state($"../Spawn")


func _on_Hurtbox_area_entered(area):
	if fsm.current_state == self and (area.is_in_group("bullet") or area.is_in_group("asteroid")):
		player.health.take_damage(5)
		player.hurt_sfx.play_random()
		player.damage_animations.play("take_damage")
