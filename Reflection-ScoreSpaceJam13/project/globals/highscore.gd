extends Node

const HIGHSCORES_FILE_PATH = "user://highscores.save"
const SILENT_WOLF_CONFIG = {
	"api_key": "l8m9ipWHTD57bmx34RjHh8tCqrn8ymNA3B4cWsN3",
	"game_id": "Reflection1",
	"game_version": "1.2.0",
	"log_level": 1}

var user_name : String = ""
var score_per_player = {}

# Configure stuff on start
func start_up():
	SilentWolf.configure(SILENT_WOLF_CONFIG)
	get_all_highscores()

# Post highscore
func post_highscore(_name, _score):
	SilentWolf.Scores.persist_score(_name, _score)

# Get all highscores
func get_all_highscores():
	yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")
	for score in SilentWolf.Scores.scores:
		if not score_per_player.has(score.player_name):
			score_per_player[score.player_name] = []
		score_per_player[score.player_name].append(str(int(score.score)))
	for player in score_per_player.keys():
		score_per_player[player].sort_custom(Globals, "sort_by_desc")
	#print(score_per_player)
	return score_per_player

# Delte all highscores
func delete_all_highscores():
	SilentWolf.Scores.wipe_leaderboard()


# Write highscore
func write(content):
	post_highscore(user_name, content)

# Read highscore
func read():
	if score_per_player.has(user_name):
		var player_scores = score_per_player[user_name]
		var _highscore = player_scores.front() as int
		return _highscore
	return 0
