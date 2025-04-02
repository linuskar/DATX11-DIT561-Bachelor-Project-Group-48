extends  Node

var connected_buildings: Dictionary[Vector2, Building]

func create_path():
	var road_path: Path2D = Path2D.new()
	return road_path

signal update_roads

var occupied_tiles: Dictionary = {}
