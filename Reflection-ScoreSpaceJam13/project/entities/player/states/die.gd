extends State

var player

func enter(_info):
	player = fsm.actor
	player.collision_shape.disabled = true
	player.hitbox.disabled = true
	player.animation_player.play("die")
