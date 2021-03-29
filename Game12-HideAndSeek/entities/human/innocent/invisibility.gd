extends Spatial

const THRESHOLD_ZERO = 0.001
export (float) var max_invisibility = 0.95
export (float) var time_to_invisible = 8.0
export (float) var slowdown_time = 3.0
export (float) var slowdown_percentage = 0.5

export (NodePath) var human_path
onready var human = get_node(human_path)
onready var start_timer = $StartTimer
onready var inv_tween = $InvTween
onready var speed_tween = $SpeedTween

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
		if invisibility > 0.5:
			slow_down()
			print("fui achado")
		inv_tween.stop_all()
		invisibility = 0.0
		is_moving = true

func slow_down():
	speed_tween.interpolate_property(human.character_mover, "speed", slowdown_percentage*human.character_mover.SLOW_SPEED, human.character_mover.SLOW_SPEED, slowdown_time)
	speed_tween.start()

func _on_StartTimer_timeout():
	inv_tween.interpolate_property(self, "invisibility", 0.0, max_invisibility, time_to_invisible)
	inv_tween.start()
