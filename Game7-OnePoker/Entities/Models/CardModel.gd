extends Node

class_name CardModel

var card_suit : int
var card_value : int


# Constructor
func init(_card_suit : int, _card_value : int):
	card_suit = _card_suit
	card_value = _card_value


# Returns the card strength: LOW or HIGH
func get_strength() -> int:
	if card_value:
		return Enums.CARD_STRENGTHS[card_value]
	return -1


# Returns 1 if this card wins, 0 if tie, -1 if enemy_card wins
func against_card(_enemy_card) -> int:
	var result : int
	var ace_value = Enums.CARD_VALUES.ACE
	var two_value = Enums.CARD_VALUES.TWO
	var me = card_value
	var enemy = _enemy_card.card_value
	if me == ace_value or enemy == ace_value:
		me = ace_value + 1 if me == two_value else me
		enemy = ace_value + 1 if enemy == two_value else enemy
	if me > enemy:
		result = 1
	elif me == enemy:
		result = 0
	else:
		result = -1
	return result


# String representation of this card
func _to_string():
	var test = Enums.CARD_NAMES[card_value]
	return str(Enums.CARD_SUITS.keys()[card_suit]) + "," + test
