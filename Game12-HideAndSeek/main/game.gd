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
			human.assassins = assassins
		human.nav = map.navigation
		if human.brain:
			human.brain.init_blackboard(self)
