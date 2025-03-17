class_name CoalMineSelectable extends SelectableBuilding

func _init() -> void:
	icon_path = "res://assets/factory.png"
	building_data = preload("res://resources/buildings/coal_mine.tres")
	cost = 50
