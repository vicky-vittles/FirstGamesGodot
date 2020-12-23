extends State

var ship

func enter():
	ship = fsm.actor

func exit():
	pass

func process(_delta):
	ship.get_input()

func physics_process(_delta):
	ship.move(_delta)
	
	if ship.input_fire:
		ship.fire()


func _on_Health_died():
	if fsm.current_state == self:
		fsm.change_state($"../Dead")


func _on_Ship_game_won(ship_victory):
	
	if ship.player_index == ship_victory:
		ship.collision_polygon.set_deferred("disabled", true)
		ship.hurtbox_polygon.set_deferred("disabled", true)
		
		fsm.change_state($"../Spawn")


func _on_Hurtbox_area_entered(area):
	if fsm.current_state == self and (area.is_in_group("bullet") or area.is_in_group("asteroid")):
		ship.health.take_damage(5)
		ship.hurt_sfx.play_random()
		ship.damage_animations.play("take_damage")
