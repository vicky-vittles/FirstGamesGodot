extends Area2D

export (int) var player_goal = 1

func _on_Goal_body_entered(body):
	
	if player_goal == 2:
		$"/root/GameVariables".player1_points += 1
		$"../../Ball".position = $"../../BallSpawn".position
		$"../../LabelP1".text = str($"/root/GameVariables".player1_points)
		
	elif player_goal == 1:
		$"/root/GameVariables".player2_points += 1
		$"../../Ball".position = $"../../BallSpawn".position
		$"../../LabelP2".text = str($"/root/GameVariables".player2_points)
