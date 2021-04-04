extends State

var human
onready var timer = $Timer
onready var IDLE = $"../Idle"
onready var DEAD = $"../Dead"

var has_applied_jump : bool = false
var can_receive_ground_signal : bool = false

func enter():
	human = fsm.actor
	timer.wait_time = human.character_mover.JUMP_TIME / 2
	timer.start()
	human.graphics.play_anim(Globals.HUMAN_WALK_ANIM)
	human.jump_sfx.play()
	has_applied_jump = false
	can_receive_ground_signal = false

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
	if fsm.current_state == self and can_receive_ground_signal:
		fsm.change_state(IDLE)

func _on_Timer_timeout():
	can_receive_ground_signal = true

func _on_Human_died(_human):
	if fsm.current_state == self:
		fsm.change_state(DEAD)
