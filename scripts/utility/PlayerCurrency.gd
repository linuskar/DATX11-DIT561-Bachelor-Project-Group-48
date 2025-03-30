extends Node

var player_held_currency: int = 0

var player_currency_gain: int = 0

func add_currency(amount: int) -> void:
	player_held_currency += amount
	
func generate_currency() -> void:
	player_held_currency += player_currency_gain

func remove_currency(amount: int) -> void:
	player_held_currency -= amount
