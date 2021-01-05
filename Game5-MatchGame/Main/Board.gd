extends Node2D

signal card_flipped(id, card_suit, card_value)
signal game_ended()

const CARD = preload("res://Entities/Card.tscn")

onready var game = get_parent()


func _ready():
	randomize()


func _process(delta):
	if self.get_child_count() == 0:
		emit_signal("game_ended")


func generate_new_board():
	for c in get_children():
		remove_child(c)
	
	var cards_to_add = []
	var cards_chosen = []
	
	for i in range(1, game.number_of_pairs + 1):
		var rand_suit = 0
		var rand_value = 0
		
		while(cards_chosen.has([rand_suit, rand_value])):
			rand_suit = randi() % 4
			rand_value = (randi() % 13) + 1
		
		cards_chosen.append([ rand_suit, rand_value ])
		
		var card_1 = CARD.instance()
		var card_2 = CARD.instance()
		
		card_1.init(rand_suit, rand_value)
		card_2.init(rand_suit, rand_value)
		
		cards_to_add.append(card_1)
		cards_to_add.append(card_2)
	
	for i in game.number_of_pairs * 2:
		var rand_index = randi() % cards_to_add.size()
		
		var rand_card = cards_to_add[rand_index]
		cards_to_add.remove(rand_index)
		
		add_child(rand_card)
		rand_card.name = str(i)
		rand_card.connect("chosen", self, "_on_Card_flipped")
		
		var pos_x = 102 * (i % 8)
		var pos_y = 138 * (ceil(float(i+1) / 8) - 1)
		rand_card.position = Vector2(pos_x, pos_y)


func debug():
	for card in get_children():
		card.debug()

func _on_Card_flipped(id, card_suit, card_value):
	emit_signal("card_flipped", id, card_suit, card_value)

func disable_all_cards():
	for card in self.get_children():
		card.disable()

func enable_all_cards():
	for card in self.get_children():
		card.enable()

func get_card_by_id(id: int):
	for card in get_children():
		if card.name == str(id):
			return card
	return null
