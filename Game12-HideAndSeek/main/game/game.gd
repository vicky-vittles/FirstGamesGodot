extends Spatial

signal game_ended()

const grace_time = 2 #30
const match_time = 300 #300

onready var ui = $UI
onready var music = $Music
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
			human.global_transform.origin = map.assassin_spawn_point
		if human is InnocentHuman:
			innocents.append(human)
			human.global_transform.origin = map.innocent_spawn_point
		human.nav = map.navigation
		if human.brain:
			human.brain.init_blackboard(self)
	
	for human in humans:
		if human is AssassinHuman:
			human.innocents = innocents
			human.all_hiding_spots = map.hiding_spots
		if human is InnocentHuman:
			human.assassins = assassins
	start_grace()

func start_grace():
	music.play()
	grace_timer.start()

func start_game():
	for assassin in assassins:
		assassin.global_transform.origin = map.innocent_spawn_point
	ui.play_anim("start_game")
	match_timer.start()


func end_of_game(winning_team):
	music.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	world_environment.set_environment(null)
	ui.set_winning_team(winning_team)
	ui.play_anim("win_game")
	cutscene_player.play("win_game")
	emit_signal("game_ended")


func human_died(human, type):
	match type:
		Globals.INNOCENT:
			innocents.remove(innocents.find(human))
			if innocents.size() == 0:
				end_of_game(Globals.ASSASSIN)

func _on_MatchTimer_timeout():
	if innocents.size() > 0:
		end_of_game(Globals.INNOCENT)
