extends State

export (Array, PackedScene) var random_enemies

func spawn_random_enemy():
	
	var n = random_enemies.size()
	
	randomize()
	var r = randi() % n
	
	var enemy = random_enemies[r].instance()
	enemy.global_position = fsm.actor.global_position
	fsm.actor.get_node("../../..").add_child(enemy)

func enter():
	$CooldownTimer.start()

func exit():
	pass

func physics_process(delta):
	pass

func _on_CooldownTimer_timeout():
	spawn_random_enemy()
