extends Node2D

signal choose_card(id, card_value)
signal animation_ended(id, anim_name)

const CARD = preload("res://Entities/Card.tscn")

onready var game = get_parent()


func _ready():
	randomize()


func generate_new_board():
	for c in get_children():
		remove_child(c)
	
	var cards_to_add = []
	var cards_chosen = []
	
	for _i in range(1, game.number_of_pairs + 1):
		var rand_value = 0
		
		while(cards_chosen.has(rand_value)):
			rand_value = (randi() % 23)
		
		cards_chosen.append(rand_value)
		
		var card_1 = CARD.instance()
		var card_2 = CARD.instance()
		
		card_1.init(rand_value)
		card_2.init(rand_value)
		
		cards_to_add.append(card_1)
		cards_to_add.append(card_2)
	
	for i in game.number_of_pairs * 2:
		var rand_index = randi() % cards_to_add.size()
		
		var rand_card = cards_to_add[rand_index]
		cards_to_add.remove(rand_index)
		
		add_child(rand_card)
		rand_card.name = str(i)
		rand_card.connect("choose_card", self, "_on_Card_chosen")
		rand_card.connect("animation_ended", self, "_on_Card_animation_ended")
		
		var pos_x = 102 * (i % 8)
		var pos_y = 138 * (ceil(float(i+1) / 8) - 1)
		rand_card.position = Vector2(pos_x + 48, pos_y + 63)


func get_card_by_id(id : int):
	for c in get_children():
		if c.name == str(id):
			return c
	return null


func get_all_closed_cards():
	var available_cards = []
	for c in get_children():
		if c.card_status == Card.CARD_STATUS.CLOSED:
			available_cards.append(c)
	return available_cards


func enable_all_cards():
	for c in get_children():
		c.enable()

func disable_all_cards():
	for c in get_children():
		c.disable()

func _on_Card_chosen(id, card_value):
	emit_signal("choose_card", id, card_value)

func _on_Card_animation_ended(id, anim_name):
	emit_signal("animation_ended", id, anim_name)
