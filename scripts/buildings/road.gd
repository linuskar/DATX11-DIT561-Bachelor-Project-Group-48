class_name Road
extends ProductionBuilding
## A class that is for the aspects of a coal power plant.
##
## A class that is for the aspects of a coal power plant. This class extends from
## the ProductionBuilding class.
##

static var road_positions: Array[Vector2] = []



func _ready():
	road_positions.append(position)
	super()
	## Test if power generates
	## input_storage.set(Enums.ResourceType.COAL, 100)
	
func _process(delta: float) -> void:
	if road_positions.has(position + Vector2(32,0)) or road_positions.has(position - Vector2(32,0)):
		$Sprite2D.frame = 4
	if road_positions.has(position + Vector2(0,32)) or road_positions.has(position - Vector2(32,0)):
		$Sprite2D.frame = 4
