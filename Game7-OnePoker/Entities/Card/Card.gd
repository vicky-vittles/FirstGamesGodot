extends Node2D

class_name Card

signal pressed(card)

const TRANS = Tween.TRANS_LINEAR
const EASE = Tween.EASE_IN_OUT
const ANIM_TIME = 0.4
const CARD_FRAMES = {
			Enums.CARD_VALUES.ACE: 0,
			Enums.CARD_VALUES.TWO: 1,
			Enums.CARD_VALUES.THREE: 2,
			Enums.CARD_VALUES.FOUR: 3,
			Enums.CARD_VALUES.FIVE: 4,
			Enums.CARD_VALUES.SIX: 5,
			Enums.CARD_VALUES.SEVEN: 6,
			Enums.CARD_VALUES.EIGHT: 7,
			Enums.CARD_VALUES.NINE: 8,
			Enums.CARD_VALUES.TEN: 9,
			Enums.CARD_VALUES.JACK: 10,
			Enums.CARD_VALUES.QUEEN: 11,
			Enums.CARD_VALUES.KING: 12}
enum FACING { UP, DOWN }

onready var model = $CardModel
onready var button = $Button
onready var front = $Front
onready var back = $Back
onready var animation_player = $AnimationPlayer
onready var tween = $Tween

var is_facing = FACING.DOWN


# Initialize using CardModel
func init(_model):
	model.init(_model.card_suit, _model.card_value)
	$Front.frame = model.card_suit * 13 + CARD_FRAMES[model.card_value]


# Constructor to use in Tests.gd
func init_test(_suit, _value):
	var _model = CardModel.new()
	_model.init(_suit, _value)
	init(_model)


# Function for passing along the pressed() signal of the button
func _on_Button_pressed():
	disable()
	emit_signal("pressed", self)


func open() -> void:
	if is_facing == FACING.UP:
		return
	is_facing = FACING.UP
	AnimationQueue.enqueue_animation(animation_player, "open")
	
func close() -> void:
	if is_facing == FACING.DOWN:
		return
	is_facing = FACING.DOWN
	AnimationQueue.enqueue_animation(animation_player, "close")

func disable() -> void:
	button.disabled = true

func enable() -> void:
	button.disabled = false


# Go to target position
func go_to_target(_target_position : Vector2, _delay = 0.0) -> void:
	tween.interpolate_property(self, "global_position", global_position, _target_position, ANIM_TIME, TRANS, EASE, _delay)
	#tween.start()
	AnimationQueue.enqueue_animation(tween)
