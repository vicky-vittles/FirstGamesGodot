extends Player

# Memory capacity / Chance that it will remember a card at any given turn
const AI_TABLE = {
				PLAYER_TYPE.EASY_AI: [10, 0.33],
				PLAYER_TYPE.NORMAL_AI: [24, 0.66],
				PLAYER_TYPE.PERFECT_AI: [32, 1.0]}

var memory = []
var found_pair = []


func init(_index : int, _type):
	init_player(_index, _type)


func play_turn(cards):
	
	if found_pair.size() == 0:
		get_pair_in_memory()
	
	if found_pair.size() > 0:
		chosen_card = found_pair.pop_front()
	else:
		var available_indexes = []
		var available_cards = game.board.get_all_closed_cards()
		for i in available_cards.size():
			available_indexes.append(int(available_cards[i].name))
		
		var rand_meta_index = randi() % available_indexes.size()
		var rand_index = available_indexes[rand_meta_index]
		chosen_card = game.board.get_card_by_id(rand_index)


func get_pair_in_memory():
	if memory.size() < 2:
		return
	
	var temp_memory = memory.duplicate(true)
	temp_memory.sort_custom(Globals, "sort_by_card_value")
	
	for i in temp_memory.size() - 1:
		if temp_memory[i].card_value == temp_memory[i+1].card_value:
			found_pair.append(temp_memory[i])
			found_pair.append(temp_memory[i+1])
			temp_memory.remove(i)
			temp_memory.remove(i+1)
			memory = temp_memory.duplicate(true)
			return


func put_in_memory(card) -> void:
	for i in memory.size():
		if int(memory[i].name) == int(card.name):
			return
	
	if memory.size() >= AI_TABLE[player_type][0]:
		memory.pop_front()
	memory.append(card)
