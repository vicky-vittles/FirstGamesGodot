extends "res://Entities/Player.gd"

signal chosen_card(player_index, card_id, card_value)

# Memory capacity / Chance that it will remember a card at any given turn
const AI_TABLE = {
				Globals.PLAYER_TYPE.EASY_AI: [10, 0.33],
				Globals.PLAYER_TYPE.NORMAL_AI: [24, 0.66],
				Globals.PLAYER_TYPE.PERFECT_AI: [32, 1.0]}

export (NodePath) var board_path

onready var board = get_node(board_path)
onready var animation_timer = $AnimationTimer

var can_play_turn : bool = false

var memory = []
var found_pair = []


func init(_index : int, _type):
	player_index = _index
	type = _type
	randomize()


func _process(delta):
	if can_play_turn:
		can_play_turn = false
		
		if found_pair.size() == 0:
			get_pair_in_memory()
		
		var card_to_choose
		if found_pair.size() > 0:
			card_to_choose = found_pair.pop_front()
		else:
			var rand_index = randi() % board.get_all_closed_cards().size()
			var c = board.get_child(rand_index)
			card_to_choose = [int(c.name), c.card_value]
		choose_card(card_to_choose[0], card_to_choose[1])


func play_turn():
	if animation_timer.is_stopped():
		animation_timer.start()


func choose_card(card_id, card_value):
	emit_signal("chosen_card", player_index, card_id, card_value)


func get_pair_in_memory():
	if memory.size() < 2:
		return
	
	var temp_memory = memory.duplicate(true)
	temp_memory.sort_custom(Globals, "sort_by_card_value")
	
	for i in temp_memory.size() - 1:
		if temp_memory[i][1] == temp_memory[i+1][1]:
			found_pair.append(temp_memory[i])
			found_pair.append(temp_memory[i+1])
			temp_memory.remove(i)
			temp_memory.remove(i+1)
			memory = temp_memory.duplicate(true)
			return


func put_in_memory(card) -> void:
	for i in memory.size():
		if memory[i][0] == card[0]:
			return
	
	if memory.size() >= AI_TABLE[type][0]:
		memory.pop_front()
	memory.append(card)


func _on_AnimationTimer_timeout():
	can_play_turn = true
