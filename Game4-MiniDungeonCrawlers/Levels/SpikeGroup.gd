extends Node2D

func disable():
	for i in get_child_count():
		var child = get_child(i)
		
		if (child is Spike):
			(child as Spike).disable()
