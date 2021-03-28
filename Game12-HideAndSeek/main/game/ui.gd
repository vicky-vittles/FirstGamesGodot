extends CanvasLayer

const MATCH_TIME_FULL_FORMAT = "%s:%s"
const MATCH_TIME_SECONDS_FORMAT = "%s"

onready var game_over_label = $root/labels/GameOverLabel
onready var match_time_label = $root/labels/MatchTimeLabel
onready var animation_player = $AnimationPlayer

func play_anim(anim_name):
	animation_player.play(anim_name)

func set_winning_team(winning_team):
	match winning_team:
		Globals.ASSASSIN:
			game_over_label.text = "ASSASSINS_WIN"
		Globals.INNOCENT:
			game_over_label.text = "INNOCENTS_WIN"

func _on_MatchTimer_match_time_update(current_time):
	var minutes = int(current_time/60)
	var seconds = int(current_time)%60
	var seconds_text = str(seconds).pad_zeros(2)
	if minutes > 0:
		match_time_label.text = MATCH_TIME_FULL_FORMAT % [minutes, seconds_text]
	else:
		match_time_label.text = MATCH_TIME_SECONDS_FORMAT % seconds_text
