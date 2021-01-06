extends Node

signal chosen_card(player_index, card_id, card_value)

# Memory capacity / Chance that it will remember a card at any given turn
const AI_TABLE = {
				Globals.PLAYER_TYPE.EASY_AI: [10, 0.33],
				Globals.PLAYER_TYPE.NORMAL_AI: [24, 0.66],
				Globals.PLAYER_TYPE.PERFECT_AI: [32, 1.0]}

var animation_timer : float
var time_of_animation : float = 0.5
var animation_timer_is_on : bool = false

var player_index : int
var type

var memory = []
var found_pair = []

func init(_index : int, _type):
	player_index = _index
	type = _type

func _process(delta):
	update_timer(delta)

func update_timer(delta):
	if animation_timer_is_on:
		animation_timer += delta
		if animation_timer >= time_of_animation:
			animation_timer = 0
			animation_timer_is_on = false

func play_turn(cards):
	if not animation_timer_is_on:
		if found_pair.size() == 0:
			get_pair_in_memory()
		
		if found_pair.size() > 0:
			var card_to_choose = found_pair.pop_front()
			choose_card(card_to_choose[0], card_to_choose[1])
		
		animation_timer_is_on = true
	print(animation_timer)

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
