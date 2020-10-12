extends State

var marked_player

func _ready():
	$"../../PlayerDetector".connect("body_exited", self, "_on_PlayerDetector_body_exited")

func enter():
	pass

func exit():
	pass

func physics_process(delta):
	
	fsm.actor.get_node("AnimationPlayer").play("run")
	
	var direction_to_player = (marked_player.global_position - fsm.actor.global_position).normalized()
	
	fsm.actor.velocity = fsm.actor.move_and_slide(direction_to_player * fsm.actor.SPEED)

func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("player"):
		fsm.change_state($"../BasicEnemyIdle")
