extends HBoxContainer

onready var slider = $Sound
onready var container = $Container
onready var label = $Container/Label
onready var timer = $Container/Timer


func _on_Sound_value_changed(value):
	var mouse_pos_x = container.get_global_mouse_position().x
	var slider_pos_x = slider.rect_global_position.x
	
	timer.start()
	container.visible = true
	
	container.global_position.x = clamp(mouse_pos_x - 25, slider_pos_x-25, slider_pos_x + slider.rect_size.x)
	label.text = str(int(value))


func _on_Timer_timeout():
	container.visible = false
