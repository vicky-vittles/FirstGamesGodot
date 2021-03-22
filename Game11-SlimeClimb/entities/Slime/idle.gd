extends State

onready var JUMP = $"../Jump"
var slime

func enter():
	slime = fsm.actor
	slime.animation_player.play("fall")

func process(_delta):
	slime.teleport()
	slime.get_direction()
	slime.prepare_jump()
	slime.turn_around(slime.direction)

func go_to_jump_state():
	if fsm.current_state == self:
		fsm.change_state(JUMP)

func _on_Slime_jump_started():
	go_to_jump_state()

func _on_Slime_teleported():
	go_to_jump_state()
