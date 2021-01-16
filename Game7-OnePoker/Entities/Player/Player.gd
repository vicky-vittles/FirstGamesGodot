extends Node2D

var presses : int = 0

func _ready():
	if not is_network_master():
		$Button.disabled = true

func _on_Button_pressed():
	presses += 1
	rpc_unreliable("set_presses_text", str(presses))

puppet func set_presses_text(text):
	$Label.text = text
