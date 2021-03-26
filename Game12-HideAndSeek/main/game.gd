extends Spatial

onready var humans = $Humans.get_children()
onready var map = $Map

func _ready():
	for human in humans:
		human.nav = map.navigation
		if human.brain:
			human.brain.init_blackboard(self)
