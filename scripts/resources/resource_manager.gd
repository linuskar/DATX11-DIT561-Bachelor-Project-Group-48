extends Node
# add types dict
@onready var map_layer: Node2D = $"../MapLayer"
@onready var build_manager: BuildManager = $"../BuildManager"

var buildings_gathering: Array[Building]

var resource_layer: TileMapLayer
var resource_tiles: Dictionary = {}

func _ready() -> void:
	build_manager.placed_building.connect(init_building_gathering)
	init_resources()

func _process(delta: float) -> void:
	gather_resources()
	
func init_resources():
	await get_tree().process_frame
	resource_layer = map_layer.get_child(4)
	
	for tile in resource_layer.get_children():
		resource_tiles[tile.position] = tile

func init_building_gathering(building: Building):
	if building.position in resource_tiles:
		buildings_gathering.append(building)
		# Start timer for gathering of resource
		# var resource_tile: GatherableResource = resource_tiles[building.position]
		# var resource_quantity: int = resource_tile.gather_resource()
		
# TEMP FUNCTION
func gather_resources():
	for building in buildings_gathering:
		var resource_tile: GatherableResource = resource_tiles[building.position]
		var resource_quantity: int = resource_tile.gather_resource()
		print("Gathered " + str(resource_quantity) + " " + Enums.ResourceType.keys()[resource_tile.resource_type])
