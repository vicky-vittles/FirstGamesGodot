extends Node2D

signal chosen(id, card_value)

class_name Card

onready var button = $Button
onready var front = $Front
onready var back = $Back
onready var animation_player = $AnimationPlayer
onready var init_timer = $InitTimer
onready var animation_timer = $AnimationTimer
onready var tween = $Tween
onready var show_timer = $ShowTimer
onready var debug_label = $DebugLabel

export (int) var card_value = 1

var is_flipped : bool = true setget set_is_flipped


func init(_value : int):
	card_value = _value
	
	$Front.frame = card_value
	$DebugLabel.text = str(card_value)


func _ready():
	init(card_value)


func set_is_flipped(value):
	is_flipped = value
	if init_timer.is_stopped():
		if value:
			animation_player.play("flip_close")
		else:
			animation_player.play("flip_open")
			emit_signal("chosen", int(self.name), card_value)


func disable():
	button.disabled = true

func enable():
	button.disabled = false

func celebrate():
	animation_timer.start()

func close():
	is_flipped = true
	animation_player.play("flip_close")

func debug():
	debug_label.show()

func exit_board(position_to_exit):
	tween.interpolate_property(self, "global_position", global_position, position_to_exit, 0.4)
	tween.start()

func choose_card():
	self.is_flipped = !self.is_flipped
	button.disabled = true


func _on_Button_pressed():
	choose_card()

func _on_AnimationPlayer_animation_finished(anim_name):
	button.disabled = false
	
	if anim_name == "celebrate":
		queue_free()

func _on_AnimationTimer_timeout():
	animation_player.play("celebrate")
