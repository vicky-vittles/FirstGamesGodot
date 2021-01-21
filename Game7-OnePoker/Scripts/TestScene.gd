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
onready var hi_lo_panel_1 = $HighLowPanel
onready var hi_lo_panel_2 = $HighLowPanel2
onready var hi_lo_panel_3 = $HighLowPanel3
onready var pos = $Position2D
onready var lives_tray = $LivesTray


func _ready():
	card_1.init_test(Enums.CARD_SUITS.CLUBS, Enums.CARD_VALUES.TWO)
	card_2.init_test(Enums.CARD_SUITS.DIAMONDS, Enums.CARD_VALUES.THREE)
	card_3.init_test(Enums.CARD_SUITS.HEARTS, Enums.CARD_VALUES.JACK)
	card_4.init_test(Enums.CARD_SUITS.SPADES, Enums.CARD_VALUES.ACE)
	card_5.init_test(Enums.CARD_SUITS.CLUBS, Enums.CARD_VALUES.QUEEN)
	card_6.init_test(Enums.CARD_SUITS.DIAMONDS, Enums.CARD_VALUES.TEN)
	
	hi_lo_panel_1.set_message(0, 2)
	hi_lo_panel_2.set_message(1, 1)
	hi_lo_panel_3.set_message(2, 0)
	
	#card_1.go_to_target(Vector2(700, 700), ANIM_DELAY)


func send_statue_to_tray(statue):
	lives_tray.put_statue(statue)


func _on_Card_pressed(card):
	card.go_to_target(Vector2(0,0))
