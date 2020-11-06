extends KinematicBody2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var ray = $RayCast2D
onready var tween = $Tween

var steps = 0
var direction = Vector2()

func _process(delta):
	if not tween.is_active():
		direction.x = -int(Input.is_action_just_pressed("left")) + int(Input.is_action_just_pressed("right"))
		direction.y = -int(Input.is_action_just_pressed("up")) + int(Input.is_action_just_pressed("down"))
	else:
		direction = Vector2()

func _physics_process(delta):
	move(direction)

func move(direction):
	if direction != Vector2.ZERO:
		var end_position = direction * Globals.TILE_SIZE
		ray.cast_to = end_position
		ray.force_raycast_update()
		tween.interpolate_property(self, "position", position, position + end_position, 0.1, TRANS, EASE)
		
		if not ray.is_colliding():
			tween.start()
			steps += 1
		else:
			var collider = ray.get_collider()
			if collider.is_in_group("boxes"):
				if collider.move(direction):
					tween.start()
					steps += 1
