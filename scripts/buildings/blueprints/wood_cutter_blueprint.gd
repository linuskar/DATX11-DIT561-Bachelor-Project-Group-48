class_name WoodCutterBlueprint
extends BuildingBlueprint
## A class that is for basic aspects of a wood cutter blueprint
##
## A class that is for aspects of a wood cutter blueprint.
## This class exetends BuildingBlueprint.
##
##

var gather_area: Polygon2D

func _ready() -> void:
	draw_gather_area()

## Function to the draw the gather area for the building
func draw_gather_area() -> void:
	gather_area = Polygon2D.new()
	
	var grid_size: int = 32
	
	## Width and height for he rectangle/square area
	var width: int = (building_data.building_size.x / 2 + building_data.gather_radius) * grid_size
	var height: int = (building_data.building_size.y / 2 + building_data.gather_radius) * grid_size
	
	## The points constructing the rectangle/square polygon
	var points: Array[Vector2] = [
		Vector2(-width, -height), Vector2(width, -height),  # Top side
		Vector2(width, height), Vector2(-width, height)  # Bottom side
	]
	
	var valid_placement_color: Color = Color(0.5, 0.5, 1, 0.6) 
	
	gather_area.polygon = PackedVector2Array(points)
	gather_area.color = Color(valid_placement_color)  
	add_child(gather_area)
