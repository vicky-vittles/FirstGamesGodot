extends State

export (PackedScene) var PROJECTILE

func enter():
	$CooldownTimer.start()
	fsm.actor.get_node("Attack").play()
	
	var aim_center_pos = fsm.actor.user.get_node("AimCenter").global_position
	
	var proj = PROJECTILE.instance()
	proj.direction = fsm.actor.direction
	proj.global_position = aim_center_pos + fsm.actor.direction * fsm.actor.reach
	proj.look_at(aim_center_pos)
	proj.rotate(-PI/2)
	
	fsm.actor.user.get_node("../../Projectiles").add_child(proj)

func exit():
	pass

func physics_process(delta):
	pass

func _on_CooldownTimer_timeout():
	fsm.change_state($"../Ready")
