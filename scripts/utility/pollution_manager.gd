class_name PollutionManager
extends Node
## A class that manages the pollution of the game.
##
## A class that manages the pollution of the game. Setting up the
## buildings that are polluting and how they apply emissions aroound them.
##
##

@onready var map_layer: MapLayer = $"../MapLayer"
@onready var build_manager: BuildManager = $"../BuildManager"

## The buildings that are polluting
var buildings_polluting: Dictionary[Building, Vector2]

## Signal for the emissions that need to be applied
signal emissions_to_apply(emissions_dict: Dictionary[Vector2, float], emission_type: Enums.ResourceType)

## Dictionary for the total emissions generated 
var emissions_generated: Dictionary[Enums.ResourceType, float]
## Dictionary for the total emissions absorbed by other objects 
var emissions_absorbed: Dictionary[Enums.ResourceType, float]

func _ready() -> void:
	emissions_generated.set(Enums.ResourceType.CO2, 0)
	emissions_generated.set(Enums.ResourceType.S02, 0)
	
	emissions_absorbed.set(Enums.ResourceType.CO2, 0)
	emissions_absorbed.set(Enums.ResourceType.S02, 0)
	
	build_manager.placed_building.connect(_init_building_polluting)

## Function for initializing buildings that pollute
func _init_building_polluting(building: Building) -> void:
	if Enums.is_a_polluting_building(building.building_type):
		buildings_polluting.set(building, building.position)
		building.emitted_emissions.connect(apply_emissions)

## Function to apply emissions emitted by a building
func apply_emissions(building: Building, emission_type: Enums.ResourceType, amount: float) -> void:
	var building_pos: Vector2 = buildings_polluting.get(building)
	var pollution_radius: int = building.pollution_radius
	emissions_to_apply.emit(emissions_falloff(amount, pollution_radius, building_pos, emission_type), emission_type)
	
## Function to calculate the emissions emitted in the area around the building
func emissions_falloff(amount: float, pollution_radius: int, building_pos: Vector2, emission_type: Enums.ResourceType) -> Dictionary[Vector2, float]:
	var emissions_dict: Dictionary[Vector2, float] = {}  
	var grid_size: int = 32
	## Iterate around the 2D area centered on the building,
	## where the area is determined by the pollution radius
	for x in range(-pollution_radius, pollution_radius + 1):
		for y in range(-pollution_radius, pollution_radius + 1):
			var tile_pos = building_pos + Vector2(x * grid_size, y * grid_size)
			## Manhattan distance, grid based
			var distance_from_building: int = abs(x) + abs(y)
			
			## If outside the pollution radius
			if distance_from_building > pollution_radius:
				continue
			
			## An exponential emission falloff
			var amount_to_set: float = amount * exp(float(-distance_from_building) / pollution_radius)
			
			## No negative amounts to set
			amount_to_set = max(amount_to_set, 0)
			emissions_dict.set(tile_pos, amount_to_set)
			set_emissions_generated(emission_type, amount_to_set)

	return emissions_dict

## Function to set the amount of emissions generated
func set_emissions_generated(emission_type, amount):
	var current_amount: float = emissions_generated.get(emission_type)
	emissions_generated.set(emission_type, amount + current_amount)

## Function to set the amount of emissions absorbed by other objects
func set_emissions_absorbed(emission_type, amount):
	var current_amount: float = emissions_absorbed.get(emission_type)
	emissions_absorbed.set(emission_type, amount + current_amount)
	
## Function to get the amount of emissions not absorbed by other objects
func get_emissions_not_absorbed(emission_type):
	var emissions_generated: float = emissions_generated.get(emission_type)
	var emissions_absorbed: float = emissions_absorbed.get(emission_type)
	return emissions_generated - emissions_absorbed
