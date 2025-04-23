extends Node

## The amount of currency the player currently holds
var player_held_currency: int = 3000000

## Signal emitted when currency is changed
signal currency_changed

## Adds an amount of currency to the players held total
func add_currency(amount: int) -> void:	
	player_held_currency += amount
	currency_changed.emit()

## Removes an amount of currency from the players held total
func remove_currency(amount: int) -> void:
	player_held_currency -= amount
