extends State

onready var IDLE = $"../Idle"
onready var respawn_timer = $RespawnTimer
var hero

func enter(info):
	hero = fsm.actor
	hero.current_lives -= 1
	hero.character.hide()
	hero.graphics.hide()
	hero.collision_shape.disabled = true
	
	respawn_timer.wait_time = hero.respawn_time
	if hero.current_lives > 0:
		respawn_timer.start()
	else:
		hero.eliminated()

func exit():
	hero.character.show()
	hero.graphics.show()
	hero.collision_shape.disabled = false

func respawn():
	if fsm.current_state == self:
		hero.respawn()
		fsm.change_state(IDLE)
