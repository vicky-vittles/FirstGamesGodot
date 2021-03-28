extends Spatial

const grace_time = 5
const match_time = 300

onready var ui = $UI
onready var map = $Map
onready var humans = $Humans.get_children()
onready var cutscene_player = $Cutscenes/CutscenePlayer
onready var world_environment = $WorldEnvironment

onready var grace_timer = $Timers/GraceTimer
onready var match_timer = $Timers/MatchTimer
var innocents = []
var assassins = []


func init(_grace_time, _match_time):
	grace_timer.wait_time = _grace_time
	match_timer.wait_time = _match_time

func _ready():
	init(grace_time, match_time)
	for human in humans:
		if human is AssassinHuman:
			assassins.append(human)
		if human is InnocentHuman:
			innocents.append(human)
		human.nav = map.navigation
		if human.brain:
			human.brain.init_blackboard(self)
	
	for human in humans:
		if human is AssassinHuman:
			human.innocents = innocents
		if human is InnocentHuman:
			human.assassins = assassins
	start_grace()

func start_grace():
	grace_timer.start()

func start_game():
	ui.play_anim("start_game")
	match_timer.start()


func end_of_game(winning_team):
	world_environment.set_environment(null)
	ui.set_winning_team(winning_team)
	ui.play_anim("win_game")
	cutscene_player.play("win_game")


func human_died(human, type):
	match type:
		Globals.INNOCENT:
			innocents.remove(innocents.find(human))
			if innocents.size() == 0:
				end_of_game(Globals.ASSASSIN)
		Globals.ASSASSIN:
			assassins.remove(assassins.find(human))
			if assassins.size() == 0:
				end_of_game(Globals.INNOCENTS)
