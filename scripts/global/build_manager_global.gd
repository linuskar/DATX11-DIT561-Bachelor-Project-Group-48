extends  Node2D

static var astar = AStarGrid2D.new()


func create_path():
	var road_path: Path2D = Path2D.new()
	return road_path

signal update_roads

var occupied_tiles: Dictionary = {}
