extends Node2D

signal obstacle_created(obstacle)

var OBSTACLE = preload("res://environment/Obstacle.tscn")

func ready():
	randomize()

func start():
	$Timer.start()

func stop():
	$Timer.stop()

func _on_Timer_timeout():
	spawn_obstacle()

func spawn_obstacle():
	var obstacle = OBSTACLE.instance()
	add_child(obstacle)
	
	obstacle.position.y = randi() % 400 + 150
	emit_signal("obstacle_created", obstacle)
