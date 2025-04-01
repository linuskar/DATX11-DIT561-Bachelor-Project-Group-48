extends CanvasLayer

signal build_list_entered

signal building_wanted(building: BuildingData)

func _on_building_select_list_build_list_entered() -> void:
	build_list_entered.emit() # Replace with function body.


func _on_building_select_list_building_wanted(building: BuildingData) -> void:
	building_wanted.emit(building)
