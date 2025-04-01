extends Control

@onready var player_currency = $Styling/HBoxContainer/MarginContainer/CurrencyAmount

func _process(delta: float) -> void:
	player_currency.text = str(PlayerCurrency.player_held_currency)
