extends Spatial

const BULLET_HIT_EFFECT = preload("res://entities/effects/bullet_hit_effect.tscn")

const NEXT_POINT_OFFSET : float = 0.2
const RAYCAST_COLLISION_MASK : int = 2+4

var current_dolly_path
onready var current_focus_point = $OriginalFocus
onready var previous_focus_point = $OriginalFocus
var current_dist : float
var current_point_t : float

var cast_ray : bool
var raycast_end_point : Vector3

onready var camera = $Camera
onready var dolly_tween = $DollyTween
onready var focus_tween = $FocusTween

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var from = camera.project_ray_origin(event.position)
		raycast_end_point = from + camera.project_ray_normal(event.position)*100.0
		cast_ray = true


func get_on_dolly_path(_path):
	current_dolly_path = _path
	var dolly_path_length = current_dolly_path.curve.get_baked_length()
	dolly_tween.interpolate_property(self, "current_dist", 0.0, dolly_path_length, current_dolly_path.speed)
	dolly_tween.start()

func get_on_focus_point(_point):
	previous_focus_point = current_focus_point
	current_point_t = 0.0
	if _point == null:
		current_focus_point = get_node("OriginalFocus")
	else:
		current_focus_point = _point


func _physics_process(delta):
	# Shooting
	if cast_ray:
		cast_ray = false
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(camera.global_transform.origin, raycast_end_point, [self], RAYCAST_COLLISION_MASK)
		if result:
			var bullet_effect = BULLET_HIT_EFFECT.instance()
			get_tree().root.add_child(bullet_effect)
			bullet_effect.global_transform.origin = result.position
			if result.normal.dot(Vector3.UP) < 0.95:
				bullet_effect.look_at(result.position + result.normal, Vector3.UP)
	
	# Movement
	if current_dolly_path:
		var current_spot = current_dolly_path.path_by(current_dist)
		var next_spot = current_dolly_path.path_by(current_dist + NEXT_POINT_OFFSET)
		global_transform.origin = current_spot
		
		if current_focus_point == get_node("OriginalFocus"):
			current_focus_point.global_transform.origin = next_spot + camera.transform.origin
		
		current_point_t = clamp(current_point_t + delta, 0.0, current_focus_point.speed)
		previous_focus_point = current_dolly_path.path_by(current_dist+NEXT_POINT_OFFSET) + camera.transform.origin
		var current_point = lerp(previous_focus_point, current_focus_point.global_transform.origin, current_point_t/current_focus_point.speed)
		if camera.global_transform.origin != current_point:
			camera.look_at(current_point, Vector3.UP)
