extends Node2D

const ANIM_DELAY = 2.0

onready var card_1 = $Card1
onready var card_2 = $Card2
onready var card_3 = $Card3
onready var card_4 = $Card4
onready var card_5 = $Card5
onready var card_6 = $Card6
onready var life_statue_1 = $LifeStatue1
onready var life_statue_2 = $LifeStatue2
onready var life_statue_3 = $LifeStatue3
onready var pos = $Position2D
onready var lives_tray = $LivesTray


func _ready():
	card_1.init_test(Enums.CARD_SUITS.CLUBS, Enums.CARD_VALUES.TWO)
	card_2.init_test(Enums.CARD_SUITS.DIAMONDS, Enums.CARD_VALUES.THREE)
	card_3.init_test(Enums.CARD_SUITS.HEARTS, Enums.CARD_VALUES.JACK)
	card_4.init_test(Enums.CARD_SUITS.SPADES, Enums.CARD_VALUES.ACE)
	card_5.init_test(Enums.CARD_SUITS.CLUBS, Enums.CARD_VALUES.QUEEN)
	card_6.init_test(Enums.CARD_SUITS.DIAMONDS, Enums.CARD_VALUES.TEN)
	
	card_1.go_to_target(Vector2(700, 700), ANIM_DELAY)


func send_statue_to_tray(statue):
	lives_tray.put_statue(statue)
