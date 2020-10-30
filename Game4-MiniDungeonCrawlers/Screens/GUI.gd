extends MarginContainer

func _ready():
	for i in range(1, 3):
		var player = get_node("../../Level/Players/Player" + str(i))
		
		player.get_node("Health").connect("update_health", self, "_on_Player_update_health")
		player.get_node("Inventory").connect("update_keys", self, "_on_Player_update_keys")
		player.get_node("Inventory").connect("update_coins", self, "_on_Player_update_coins")


func set_player_portrait(player_index, texture):
	var sprite = get_node("Background/Player" + str(player_index) + "/Face")
	sprite.texture = texture


func _on_Player_update_health(player_index, new_amount):
	var player = get_node("Background/Player" + str(player_index))
	
	for h in range(1, 4):
		var heart = player.get_node("Heart" + str(h))
		
		var x = clamp(new_amount - 2*(h-1), 0, 2)
		var frame = 2 - x
		
		heart.frame = frame


func _on_Player_update_keys(player_index, silver_amount, gold_amount):
	
	var player = get_node("Background/Player" + str(player_index))
	
	for i in range(1, 5):
		player.get_node("Key" + str(i)).frame = 0
	
	for i in range(1, silver_amount + 1):
		player.get_node("Key" + str(i)).frame = 1
	
	if gold_amount > 0:
		player.get_node("Key" + str(silver_amount + gold_amount)).frame = 2


func _on_Player_update_coins(player_index, new_amount):
	
	var player = get_node("Background/Player" + str(player_index))
	
	var coins = str(new_amount)
	
	var hundreds
	var tens
	var ones
	
	if new_amount < 10:
		hundreds = 0
		tens = 0
		ones = int(coins[0])
		
	elif new_amount < 100:
		hundreds = 0
		tens = int(coins[0])
		ones = int(coins[1])
		
	elif new_amount < 1000:
		hundreds = int(coins[0])
		tens = int(coins[1])
		ones = int(coins[2])
	
	player.get_node("CoinLabel").text = str(hundreds) + str(tens) + str(ones)
