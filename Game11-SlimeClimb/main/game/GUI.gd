extends CanvasLayer

onready var current_stage = $root/CurrentStage

func update_stage(level_id: int):
	current_stage.text = tr("LEVEL_LABEL") % str(level_id).pad_zeros(2)
