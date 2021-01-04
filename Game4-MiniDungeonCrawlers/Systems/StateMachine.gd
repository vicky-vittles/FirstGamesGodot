extends Node

class_name StateMachine

export (NodePath) var actor_path
var actor
var current_state : Object

var is_active = true

func _ready():
	if actor_path:
		actor = get_node(actor_path)
	actor.connect("ready", self, "_on_Actor_ready")

func _on_Actor_ready():
	if is_active:
		current_state = get_child(0)
		current_state.enter()

func change_state(new_state):
	if is_active:
		current_state.exit()
		current_state = new_state
	
		new_state.enter()

func _physics_process(delta):
	if is_active and current_state.has_method("physics_process"):
		current_state.physics_process(delta)

func disable():
	is_active = false
