extends Player

# Memory capacity / Chance that it will remember a card at any given turn
const AI_TABLE = {
				PLAYER_TYPE.EASY_AI: [10, 0.33],
				PLAYER_TYPE.NORMAL_AI: [24, 0.75],
				PLAYER_TYPE.PERFECT_AI: [32, 1.0]}

var memory = []
var found_pair = []


func init(_index : int, _type):
	init_player(_index, _type)
	randomize()


func _process(_delta):
	var cards_to_remove = []
	for i in memory.size():
		if memory[i].card_status == Card.CARD_STATUS.OUT_OF_GAME:
			cards_to_remove.append(memory[i])
	for i in cards_to_remove.size():
		memory.remove(memory.find(cards_to_remove[i]))
		#print(cards_to_remove[i].name + "," + str(cards_to_remove[i].card_value) + " removida carta")


func play_turn(_cards):
	if game.board.get_all_closed_cards().size() == 0:
		return
	
	if found_pair.size() == 0:
		var _did_find_pair = get_pair_in_memory()
	
	var rand_chance = (randi() % 100) + 1
	var chance_of_hitting = 100 * AI_TABLE[player_type][1]
	
	if found_pair.size() > 0 and rand_chance <= chance_of_hitting:
		#print("lembrou")
		chosen_card = found_pair.pop_front()
	else:
		var available_indexes = []
		var available_cards = game.board.get_all_closed_cards()
		for i in available_cards.size():
			available_indexes.append(int(available_cards[i].name))
		
		var rand_meta_index = randi() % available_indexes.size()
		var rand_index = available_indexes[rand_meta_index]
		chosen_card = game.board.get_card_by_id(rand_index)


func get_pair_in_memory() -> bool:
	if memory.size() < 2:
		return false
	
	var has_found_pair = false
	var temp_memory = memory.duplicate(true)
	temp_memory.sort_custom(Globals, "sort_by_card_value")
	
	for i in temp_memory.size() - 1:
		if temp_memory[i].card_value == temp_memory[i+1].card_value:
			found_pair.append(temp_memory[i])
			found_pair.append(temp_memory[i+1])
			has_found_pair = true
	
	if has_found_pair:
		for i in found_pair.size():
			var index = temp_memory.find(found_pair[i])
			#print(temp_memory[index].name + "," + str(temp_memory[index].card_value) + " removida carta")
			temp_memory.remove(index)
		memory = temp_memory.duplicate(true)
	return has_found_pair


func put_in_memory(card) -> void:
	for i in found_pair.size():
		if int(found_pair[i].name) == int(card.name):
			return
	
	for i in memory.size():
		if int(memory[i].name) == int(card.name):
			return
	
	if memory.size() >= AI_TABLE[player_type][0]:
		memory.pop_front()
	memory.append(card)
	#print(card.name + "," + str(card.card_value) + " nova carta")
