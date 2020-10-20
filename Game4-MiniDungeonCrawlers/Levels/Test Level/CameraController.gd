extends Camera2D

func _process(delta):
	
	var p1_pos = $"../Players/Player1".global_position
	var p2_pos = $"../Players/Player2".global_position
	
	position = (p1_pos + p2_pos) / 2
