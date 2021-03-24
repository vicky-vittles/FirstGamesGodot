extends State

var human
onready var IDLE = $"../Idle"
onready var WALK = $"../Walk"

var has_applied_jump : bool = false

func enter():
	human = fsm.actor
	human.graphics.play_anim(Globals.HUMAN_WALK_ANIM)
	has_applied_jump = false

func input(event):
	human.event_input(event)

func process(delta):
	human.get_input()

func physics_process(delta):
	if not has_applied_jump:
		human.character_mover.apply_jump(delta)
		has_applied_jump = true
	human.full_movement(delta)

func _on_CharacterMover_on_ground():
	if fsm.current_state == self:
		fsm.change_state(IDLE)
