extends Node2D

signal infect_animation_finished()

onready var graphics = get_parent()
onready var tween = $Tween

var enemy_pos : Vector2


func play_infect(infected_enemy):
	graphics.animation_player.play("infect")
	enemy_pos = infected_enemy.global_position
	var target_pos = infected_enemy.behind_position.global_position
	var target_direction = infected_enemy.global_transform.x
	
	var dist = (target_pos - graphics.player.global_position).length()
	var time = dist/graphics.player.stats.INFECT_SPEED
	
	tween.interpolate_property(self, "global_position", global_position, target_pos, time)
	tween.interpolate_property(self, "global_rotation_degrees", global_rotation_degrees, rad2deg(target_direction.angle()), time)
	tween.start()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "infect":
		enemy_pos = Vector2.ZERO
		position = Vector2.ZERO
		rotation_degrees = 0.0
		emit_signal("infect_animation_finished")
