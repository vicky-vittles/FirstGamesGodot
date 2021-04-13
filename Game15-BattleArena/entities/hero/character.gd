extends Node2D

onready var hero = get_parent()
onready var collector = $Collector

func _physics_process(delta):
	collector.toggle(hero.equip_press)
