extends Node

class_name StateMachine

export (NodePath) var actor_path
onready var actor = get_node(actor_path)
var current_state : Object

func _ready():
	actor.connect("ready", self, "_on_Actor_ready")

func _on_Actor_ready():
	current_state = get_child(0)
	current_state.enter()

func change_state(new_state):
	current_state.exit()
	current_state = new_state
	
	new_state.enter()

func _physics_process(delta):
	if current_state.has_method("physics_process"):
		current_state.physics_process(delta)