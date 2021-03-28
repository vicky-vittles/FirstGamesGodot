extends Spatial

signal human_died(human, type)

onready var game = get_parent()

func _ready():
	connect_signals()

func connect_signals():
	for human in get_children():
		human.connect("died", self, "_on_Human_died")

func _on_Human_died(human):
	if human is InnocentHuman:
		emit_signal("human_died", human, Globals.INNOCENT)
	if human is AssassinHuman:
		emit_signal("human_died", human, Globals.ASSASSIN)
