extends Node2D

func _ready():
	$Player.connect("player_died", self, "_on_Player_player_died")
	$DeathZone.hit.team = "death_zone"

func _physics_process(delta):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	
	$ActionPlayZone.global_position.x = clamp($Player.global_position.x, 160, 2400)

func _on_Player_player_died():
	get_tree().reload_current_scene()

func _on_ActionPlayZone_body_entered(body):
	if body is Enemy:
		(body as Enemy).fsm.activate()

func _on_ActionPlayZone_body_exited(body):
	if body is Enemy:
		(body as Enemy).fsm.deactivate()
