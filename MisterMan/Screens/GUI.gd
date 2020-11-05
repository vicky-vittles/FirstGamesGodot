extends MarginContainer

var heart_full = preload("res://Assets/GUI/heart_container.png")
var heart_empty = preload("res://Assets/GUI/empty_container.png")
var numbers = []


func _ready():
	for i in range(10):
		var path = "res://Assets/GUI/number_" + str(i) + ".png"
		numbers.append(load(path))
	
	$"/root/PlayerVariables".connect("update_coins", self, "_on_Player_update_coins")
	$"../../Player".connect("update_health", self, "_on_Player_update_health")


func _on_Player_update_health(new_amount):
	new_amount = clamp(new_amount, 0, 3)
	for i in $HBoxContainer/Hearts.get_child_count():
		if new_amount > i:
			$HBoxContainer/Hearts.get_child(i).texture = heart_full
		else:
			$HBoxContainer/Hearts.get_child(i).texture = heart_empty


func _on_Player_update_coins(new_amount):
	
	var coins = str(new_amount)
	
	var tens
	var ones
	if new_amount < 10:
		tens = 0
		ones = int(coins[0])
	elif new_amount < 100:
		tens = int(coins[0])
		ones = int(coins[1])
	
	$HBoxContainer/Coins/Tens.texture = numbers[tens]
	$HBoxContainer/Coins/Ones.texture = numbers[ones]
