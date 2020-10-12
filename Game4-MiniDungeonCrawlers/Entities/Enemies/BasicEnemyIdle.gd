extends State

func _ready():
	$"../../PlayerDetector".connect("body_entered", self, "_on_PlayerDetector_body_entered")

func enter():
	pass

func exit():
	pass

func physics_process(delta):
	fsm.actor.get_node("AnimationPlayer").play("idle")

func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player"):
		fsm.change_state($"../BasicEnemyRun")
		$"../BasicEnemyRun".marked_player = body
