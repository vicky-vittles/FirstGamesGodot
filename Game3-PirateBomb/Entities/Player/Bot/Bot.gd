extends Player

signal draw_line(points)

export (NodePath) var navigation_2d_node_path

onready var navigation_2d = get_node(navigation_2d_node_path)
onready var behavior_tree = character.get_node("BehaviorTreeRoot")
onready var line_2d = get_node("Line2D")

func _ready():
	behavior_tree.enable()

func _input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	
	print(self.global_position)
	print(event.position)
	var new_path = navigation_2d.get_simple_path(self.global_position, get_viewport().get_mouse_position())
	emit_signal("draw_line", new_path)

func get_input():
	pass
