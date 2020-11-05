extends Node
class_name StateMachine

onready var parent = get_parent()

var current_state = null
var previous_state = null
var states = {}

# Physics process for state
func _physics_process(delta):
	if current_state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		
		if transition != null:
			set_state(transition)

# Will be called in physics_process
func _state_logic(delta):
	pass

# Check for transitions and return necessary transition
func _get_transition(delta):
	return null;

# On enter state
func _enter_state(new_state, old_state):
	pass

# On exit state
func _exit_state(old_state, new_state):
	pass

# Set new state, exiting the old one and entering the new one
func set_state(new_state):
	previous_state = current_state
	current_state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, current_state)
	
	if new_state != null:
		_enter_state(current_state, previous_state)

# Add new state to dictionary
func add_state(state_name):
	states[state_name] = states.size()
