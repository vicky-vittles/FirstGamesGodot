extends Node

class_name StateMachine

var current_state
var previous_state
var actor

func _ready():
	actor = $".."
	current_state = get_child(0)
	previous_state = get_child(0)
	enter_state()

func change_state(new_state):
	previous_state = current_state
	current_state = new_state
	enter_state()

func enter_state():
	current_state.fsm = self
	current_state.enter()


func _process(delta):
	if current_state.has_method("process"):
		current_state.process(delta)

func _physics_process(delta):
	if current_state.has_method("physics_process"):
		current_state.physics_process(delta)

func activate():
	if current_state.has_method("activate"):
		current_state.activate()

func deactivate():
	if current_state.has_method("deactivate"):
		current_state.deactivate()
