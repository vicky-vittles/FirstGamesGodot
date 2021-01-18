extends Node2D

const TRANS = Tween.TRANS_LINEAR
const EASE = Tween.EASE_IN_OUT
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

onready var front = $Front
onready var back = $Back
onready var animation_player = $AnimationPlayer
onready var tween = $Tween

var model : CardModel
var is_facing = FACING.DOWN


# Initialize using CardModel
func init(_model):
	model = _model
	$Front.frame = model.card_suit * 13 + CARD_FRAMES[model.card_value]
	if is_facing == FACING.DOWN:
		$AnimationPlayer.play("open")
	else:
		$AnimationPlayer.play("close")


# Constructor to use in Tests.gd
func init_test(_suit, _value):
	var _model = CardModel.new()
	_model.init(_suit, _value)
	init(_model)


# Go to target position
func go_to_target(_target_position : Vector2, _delay = 0.0) -> void:
	tween.interpolate_property(self, "global_position", global_position, _target_position, 1, TRANS, EASE, _delay)
	tween.start()
	#AnimationQueue.enqueue_animation(tween)
