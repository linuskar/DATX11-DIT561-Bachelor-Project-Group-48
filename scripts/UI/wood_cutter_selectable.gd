class_name RoadSelectable extends SelectableBuilding

func _init() -> void:
	icon_path = "res://assets/buildings/väg_vertical.png"
	building_data = preload("res://resources/buildings/road.tres")
	cost = 30
