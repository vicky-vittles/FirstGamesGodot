extends Node2D

signal chosen(id, card_suit, card_value)

class_name Card

onready var button = $Button
onready var front = $Front
onready var back = $Back
onready var animation_player = $AnimationPlayer
onready var init_timer = $InitTimer
onready var show_timer = $ShowTimer
onready var debug_label = $DebugLabel

export (int) var card_value = 1
export (Enums.CARD_SUITS) var card_suit

var is_flipped : bool = true setget set_is_flipped


func init(_suit, _value : int):
	card_suit = _suit
	card_value = _value
	
	$Front.frame = int(card_suit) * 13 + (card_value-1)
	$DebugLabel.text = str(int(card_suit)) + " and " + str(card_value)


func _ready():
	init(card_suit, card_value)


func set_is_flipped(value):
	is_flipped = value
	if init_timer.is_stopped():
		if value:
			animation_player.play("flip_close")
		else:
			animation_player.play("flip_open")
			emit_signal("chosen", int(self.name), card_suit, card_value)


func disable():
	button.disabled = true

func enable():
	button.disabled = false

func close():
	is_flipped = true
	animation_player.play("flip_close")

func debug():
	debug_label.show()


func _on_Button_pressed():
	self.is_flipped = !self.is_flipped
	button.disabled = true

func _on_AnimationPlayer_animation_finished(anim_name):
	button.disabled = false
