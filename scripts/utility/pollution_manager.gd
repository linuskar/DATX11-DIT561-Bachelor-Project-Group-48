class_name PollutionManager
extends Node


@onready var map_layer: MapLayer = $"../MapLayer"
@onready var build_manager: BuildManager = $"../BuildManager"

var buildings_polluting: Dictionary[Building, Vector2]

signal co2_emitted(co2_dict: Dictionary[Vector2, int])

func _ready() -> void:
	build_manager.placed_building.connect(_init_building_polluting)

func _init_building_polluting(building: Building) -> void:
	if Enums.is_a_polluting_building(building.building_type):
		print(Enums.building_type_to_string(building.building_type))
		buildings_polluting.set(building, building.position)
		print(building.position)
		building.emitted_emissions.connect(apply_emissions)

func apply_emissions(building, emission_type, amount) -> void:
	var building_pos: Vector2 = buildings_polluting.get(building)
	var pollution_radius: int = building.pollution_radius
	
	## Dictionary to store levels of co2 for tiles
	var co2_dict: Dictionary[Vector2, int] = {}  
	
	match emission_type:
		Enums.ResourceType.CO2:
			for x in range(-pollution_radius, pollution_radius + 1):
				for y in range(-pollution_radius, pollution_radius + 1):
					## TODO: Make CO2 decrease the farther away it is within the radius
					var tile_pos = building_pos + Vector2(x*32, y*32)
					var amount_to_set: int = 0
					#print("Tile pos to apply emission: " + str(tile_pos))
					if co2_dict.has(building_pos):
						amount_to_set = co2_dict.get(building_pos)
						
					amount_to_set += amount
					co2_dict.set(tile_pos, amount_to_set)
			co2_emitted.emit(co2_dict)
			print("CO2 tiles to apply" + str(co2_dict.size()))
		_:
			pass
