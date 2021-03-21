extends State

onready var IDLE = $"../Idle"
var slime

func enter():
	slime = fsm.actor
	slime.animation_player.play("jump")

func exit():
	slime.dust_particles.amount = lerp(20, 30, abs(slime.velocity.y/slime.aux_speed))
	slime.dust_particles.restart()
	slime.dust_particles.emitting = true

func physics_process(delta):
	slime.move(delta)
	slime.turn_around(slime.direction)

func _on_Slime_on_floor():
	if fsm.current_state == self:
		fsm.change_state(IDLE)
