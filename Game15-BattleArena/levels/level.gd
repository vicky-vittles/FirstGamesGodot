extends Node2D

export (Color) var environment_color = Color("#130c37")
onready var spawn_points = $SpawnPoints.get_children()
onready var collectable_spawn_area = $CollectableSpawnArea

func _ready():
	VisualServer.set_default_clear_color(environment_color)
