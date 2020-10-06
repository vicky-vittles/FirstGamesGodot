extends Area2D

class_name Explosion

export (Resource) var hit

func _ready():
	var random_pitch = 1 + (scale.x - 1)
	
	$ExplosionSFX.pitch_scale = random_pitch
	$ExplosionSFX.play()
	
	$AnimatedSprite.play("default")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "default":
		get_parent().remove_child(self)
		queue_free()
