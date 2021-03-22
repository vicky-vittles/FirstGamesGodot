extends CanvasLayer

onready var current_stage = $root/CurrentStage
onready var click_to_jump = $root/Position2D/ClickToJump
onready var animation_player = $AnimationPlayer
onready var game_over = $root/GameOver

func update_stage(level_id: int):
	current_stage.text = tr("LEVEL_LABEL") % str(level_id).pad_zeros(2)
	animation_player.queue("new_level")

func _on_Game_game_started():
	animation_player.stop()
	animation_player.queue("game_started")

func _on_Game_game_ended():
	animation_player.stop()
	animation_player.queue("game_ended")
	get_tree().paused = true
