extends CanvasLayer

onready var color_rect = $ColorRect
onready var particles = $CPUParticles2D

func _ready():
	color_rect.color = Settings.theme["background"]
