extends Node2D

const ALLY_ARMED_HUMAN = preload("res://entities/allies/ally_armed_human/ally_armed_human.tscn")

func _on_Enemies_spawn_ally(pos):
	var ally = ALLY_ARMED_HUMAN.instance()
	add_child(ally)
	ally.global_position = pos
