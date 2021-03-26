extends CSGSphere

func _physics_process(delta):
	if Globals.DEBUG_MODE:
		visible = true
	else:
		visible = false
