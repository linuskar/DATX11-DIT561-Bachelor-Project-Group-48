extends Control
## A class that is for the GUI of selecting a builing.
##
## A class that is for the GUI of selecting a builing to place down.
##

## Function handling when a item in the list is clicked
func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if $ItemList.get_item_text(index) == "Factory":
		print("place building")
