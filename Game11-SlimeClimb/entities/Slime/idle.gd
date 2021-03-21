extends State

onready var JUMP = $"../Jump"
var slime

func enter():
	slime = fsm.actor
	slime.animation_player.play("fall")

func process(_delta):
	slime.get_direction()
	slime.prepare_jump()
	slime.turn_around(slime.direction)

func _on_Slime_jump_started():
	if fsm.current_state == self:
		fsm.change_state(JUMP)
