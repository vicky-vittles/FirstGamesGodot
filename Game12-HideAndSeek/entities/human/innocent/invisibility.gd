extends Spatial

const THRESHOLD_ZERO = 0.001
export (float) var max_invisibility = 0.95
export (float) var time_to_invisible = 8.0
export (NodePath) var human_path
onready var human = get_node(human_path)
onready var start_timer = $StartTimer
onready var tween = $Tween

var invisibility : float = 0.0
var is_moving : bool = false

func _physics_process(delta):
	human.graphics.set_transparency(invisibility)

func _on_CharacterMover_movement_info(body, velocity, is_grounded):
	var ground_velocity = Vector3(1,0,1) * velocity
	var length = ground_velocity.length()
	var is_near_zero = length <= THRESHOLD_ZERO and length >= -THRESHOLD_ZERO
	
	if is_moving and is_near_zero and is_grounded:
		start_timer.start()
		is_moving = false
	if not is_moving and (not is_near_zero or not is_grounded):
		start_timer.stop()
		tween.stop_all()
		invisibility = 0.0
		is_moving = true

func _on_StartTimer_timeout():
	tween.interpolate_property(self, "invisibility", 0.0, max_invisibility, time_to_invisible)
	tween.start()
