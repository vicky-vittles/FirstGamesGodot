extends Player

func init(_index : int):
	init_player(_index, PLAYER_TYPE.HUMAN)

func play_turn(cards):
	if game.clicked_card:
		chosen_card = game.clicked_card
