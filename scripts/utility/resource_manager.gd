extends Node
# add types dict
@onready var map_layer: Node2D = $"../MapLayer"
var resource_layer: TileMapLayer
var resource_tiles: Dictionary = {}
@onready var build_manager: BuildManager = $"../BuildManager"

func _ready() -> void:
	init_resources()

func _process(delta: float) -> void:
	gather_resources()
	# print(resource_tiles.size())
	
func init_resources():
	await get_tree().process_frame
	resource_layer = map_layer.get_child(4)
	print(resource_layer.name)
	var count = resource_layer.get_child_count()
	
	print("There are " + str(count) + " resources")
	for tile in resource_layer.get_children():
		resource_tiles[tile.position] = tile.resource_type
		#print(Enums.ResourceType.keys()[tile.resource_type])
		
	#print(resource_tiles.size())

	
func gather_resources():
	## build manager factories
	## if building on tile with resource then gather
	## call get resource on that tile
	
	var buildings = build_manager.buildings_placed
	
	for building in buildings:
		if building.position in resource_tiles:
			var resource_tile = resource_tiles[building.position]
			print(resource_tile)
			#print(resource_tile.get_name())
			#resource_tile.gather_resource()
			
