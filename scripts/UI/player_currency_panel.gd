extends Control

@onready var player_currency = $Styling/HBoxContainer/CurrencyAmount

func _process(delta: float) -> void:
	player_currency.text = str(PlayerCurrency.player_held_currency)
