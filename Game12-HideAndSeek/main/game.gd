extends Spatial

onready var humans = $Humans.get_children()
onready var map = $Map
var innocents = []
var assassins = []

func _ready():
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
