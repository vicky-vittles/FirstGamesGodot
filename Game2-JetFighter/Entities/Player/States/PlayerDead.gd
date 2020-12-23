extends State

onready var timer = $Timer
var player

func enter():
	player = fsm.actor
	
	timer.start()
	player.collision_polygon.set_deferred("disabled", true)
	player.hurtbox_polygon.set_deferred("disabled", true)
	player.particle_spawn.emitting = true

func exit():
	player.particle_spawn.emitting = false

func process(delta):
	pass

func physics_process(delta):
	if not player.damage_animations.is_playing():
		player.damage_animations.play("died")

func _on_Timer_timeout():
	fsm.change_state($"../Hidden")
