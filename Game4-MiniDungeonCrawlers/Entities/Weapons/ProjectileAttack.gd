extends State

export (PackedScene) var PROJECTILE

func enter():
	$CooldownTimer.start()
	
	var aim_center_pos = fsm.actor.player.get_node("AimCenter").global_position
	
	var proj = PROJECTILE.instance()
	proj.direction = fsm.actor.direction
	proj.global_position = aim_center_pos + fsm.actor.direction * fsm.actor.reach
	proj.look_at(aim_center_pos)
	proj.rotate(-PI/2)
	
	add_child(proj)

func exit():
	pass

func physics_process(delta):
	pass

func _on_CooldownTimer_timeout():
	fsm.change_state($"../Ready")
