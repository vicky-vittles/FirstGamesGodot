tool
extends MeshInstance

func _ready():
	if not Engine.editor_hint:
		hide()
