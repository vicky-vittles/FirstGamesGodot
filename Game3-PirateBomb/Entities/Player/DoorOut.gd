extends State

var door_to_exit

var door_animation_finished = false

func _ready():
	$"../../AnimatedSprite".connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

func enter():
	$"../../AnimatedSprite".play("door_out")
	fsm.actor.acceleration.y = Player.JUMP_ASCENT_GRAVITY

func exit():
	pass

func physics_process(delta):
	
	if door_animation_finished:
		
		door_animation_finished = false
		
		fsm.change_state($"../Idle")

func _on_AnimatedSprite_animation_finished():
	if $"../../AnimatedSprite".animation == "door_out" and fsm.current_state == self:
		door_animation_finished = true
		door_to_exit.close()
