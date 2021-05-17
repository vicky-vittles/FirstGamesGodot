extends Node2D

const LASER = preload("res://entities/laser/laser.tscn")


func _ready():
	randomize()
#	get_node("Laser").init(Vector2(1,0).rotated(deg2rad(randf()*360)))
#	get_node("Laser2").init(Vector2(1,0).rotated(deg2rad(randf()*360)))
#	get_node("Laser3").init(Vector2(1,0).rotated(deg2rad(randf()*360)))
#	get_node("Laser4").init(Vector2(1,0).rotated(deg2rad(randf()*360)))
#	get_node("Laser5").init(Vector2(1,0).rotated(deg2rad(randf()*360)))
#	get_node("Laser6").init(Vector2(1,0).rotated(deg2rad(randf()*360)))


func spawn_copy(point: Vector2, dir: Vector2, laser_level: int, is_immediate: bool):
	var new_laser = LASER.instance()
	add_child(new_laser)
	new_laser.connect("spawn_copy", self, "spawn_copy")
	new_laser.global_position = point
	new_laser.init(dir, laser_level, is_immediate)
