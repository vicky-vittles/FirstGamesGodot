extends Node2D

export (NodePath) var spike_path
onready var main_spike = get_node(spike_path)

func _ready():
	main_spike.get_node("TimerToOn").connect("timeout", self, "_on_TimerToOn_timeout")

func _on_TimerToOn_timeout():
	$Activate.play()

func disable():
	for i in get_child_count():
		var child = get_child(i)
		
		if (child is Spike):
			(child as Spike).disable()
