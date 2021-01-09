extends Node2D

class_name Card

signal choose_card(id, card_value)
signal animation_ended(id, name)

onready var button = $Button
onready var front = $Front
onready var back = $Back
onready var animation_player = $AnimationPlayer
onready var tween = $Tween
onready var debug_label = $DebugLabel

enum CARD_STATUS { OPEN, CLOSED, OUT_OF_GAME }

var card_status
var card_value : int = 0


func init(_value : int):
	card_status = CARD_STATUS.CLOSED
	card_value = _value
	$Front.frame = card_value


func _ready():
	init(card_value)


func _process(_delta):
	if Globals.debug_mode:
		debug_label.show()


func open() -> bool:
	if card_status != CARD_STATUS.CLOSED:
		return false
	
	card_status = CARD_STATUS.OPEN
	button.disabled = true
	animation_player.play("open")
	
	return true


func close() -> bool:
	if card_status != CARD_STATUS.OPEN:
		return false
	
	card_status = CARD_STATUS.CLOSED
	button.disabled = false
	animation_player.play("close")
	
	return true


func get_captured():
	if card_status == CARD_STATUS.OUT_OF_GAME:
		return
	
	card_status = CARD_STATUS.OUT_OF_GAME
	animation_player.play("celebrate")


func exit_board(position_to_exit):
	tween.interpolate_property(self, "global_position", global_position, position_to_exit, 0.4)
	tween.start()


func enable():
	button.disabled = false

func disable():
	button.disabled = true

func is_openable() -> bool:
	return card_status == CARD_STATUS.CLOSED

func _to_string() -> String:
	return "Id:" + str(int(self.name)) + ". Value:" + str(card_value)

func _on_Button_pressed():
	emit_signal("choose_card", int(self.name), card_value)

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("animation_ended", int(self.name), anim_name)
