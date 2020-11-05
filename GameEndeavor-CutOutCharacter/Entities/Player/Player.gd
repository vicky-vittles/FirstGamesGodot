extends KinematicBody2D

onready var animation_player = $Body/CharacterRig/AnimationPlayer

func _ready():
	animation_player.play("run")
