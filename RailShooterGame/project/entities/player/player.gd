extends Spatial

const NEXT_POINT_OFFSET : float = 0.2

var current_dolly_path
var current_focus_point
var current_dist : float
var current_rot : Vector3

var raycast_end_point : Vector3

onready var camera = $Camera
onready var dolly_tween = $DollyTween
onready var focus_tween = $FocusTween

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var from = camera.project_ray_origin(event.position)
		raycast_end_point = from + camera.project_ray_normal(event.position)*100.0


func get_on_dolly_path(_path):
	current_dolly_path = _path
	var dolly_path_length = current_dolly_path.curve.get_baked_length()
	dolly_tween.interpolate_property(self, "current_dist", 0.0, dolly_path_length, current_dolly_path.speed)
	dolly_tween.start()

func get_on_focus_point(_point):
	current_focus_point = _point
	if _point:
		var current_rotation = camera.rotation_degrees
		camera.look_at(current_focus_point.global_transform.origin, Vector3.UP)
		var future_rotation = camera.rotation_degrees
		camera.rotation_degrees = current_rotation
		focus_tween.interpolate_property(self, "current_rot", current_rotation, future_rotation, 0.5)
		focus_tween.start()


func _physics_process(delta):
	if current_dolly_path:
		var current_spot = current_dolly_path.curve.interpolate_baked(current_dist)
		var next_spot = current_dolly_path.curve.interpolate_baked(current_dist+NEXT_POINT_OFFSET)
		global_transform.origin = current_spot
		
		if not current_focus_point:
			if current_spot != next_spot:
				camera.look_at(next_spot + camera.transform.origin, Vector3.UP)
	
	if current_focus_point:
		if focus_tween.is_active():
			camera.rotation_degrees = current_rot
		else:
			camera.look_at(current_focus_point.global_transform.origin, Vector3.UP)
