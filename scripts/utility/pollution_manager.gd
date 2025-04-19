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
@onready var timer: Timer = $Timer

## The buildings that are polluting
var buildings_polluting: Dictionary[Building, Vector2]

## Signal for the emissions that need to be applied
signal emissions_to_apply(emissions_dict: Dictionary[Vector2, float], emission_type: Enums.ResourceType)

## Dictionary for the total emissions generated 
var emissions_generated: Dictionary[Enums.ResourceType, float]
## Dictionary for the total emissions absorbed by other objects 
var emissions_absorbed: Dictionary[Enums.ResourceType, float]

var ongoing_wildfire: bool = false
var wildfire_percentage: float = 0.0
var wait_time: float = 10.0
var upper_limit: float = pow(10,8)

func _ready() -> void:
	emissions_generated.set(Enums.ResourceType.CO2, 0)
	emissions_generated.set(Enums.ResourceType.S02, 0)
	
	emissions_absorbed.set(Enums.ResourceType.CO2, 0)
	emissions_absorbed.set(Enums.ResourceType.S02, 0)
	
	build_manager.placed_building.connect(_init_building_polluting)
	
func _on_timer_timeout() -> void:
	try_start_wildfire()

## TODO: make co2 decay, so the co2 amount wont be stuck at a fixed amount forever,
## for example not forever at upper limit
func update_wildfire_percentage() -> void:
	## sum up values to get percentage, for every emission amount that can contribute
	## to wildfires
	var co2_amount: float = get_emissions_not_absorbed(Enums.ResourceType.CO2)
	var normalized: float = inverse_lerp(0.0, upper_limit, co2_amount)
	wildfire_percentage = normalized
	print("Wildfire percentage: " + str(wildfire_percentage))
	
func try_start_wildfire():
	check_for_wildfire()
	
	if ongoing_wildfire:
		return 
		
	update_wildfire_percentage()
	start_wildfire()
	
func check_for_wildfire() -> void:
	var all_trees: Array[Node] = get_tree().get_nodes_in_group("trees")
	var trees_burning: Array[Node] = []
	for tree in all_trees:
		if tree.burn_state == Enums.BurnState.BURNING:
			trees_burning.append(tree)
			
	if trees_burning.size() == 0:
		ongoing_wildfire = false
		print("no wildfire")
		
func start_wildfire() -> void:
	if ongoing_wildfire == false:
		var random_number: float = randf()

		print(random_number)
		if random_number <= wildfire_percentage:
			var all_trees: Array[Node] = get_tree().get_nodes_in_group("trees")
			var random_index: int = randi_range(0, all_trees.size()-1)
			var random_tree: GatherableTree = all_trees[random_index]
			random_tree.start_burning()
			ongoing_wildfire = true
			print("wildfire started")

## Function for initializing buildings that pollute
func _init_building_polluting(building: Building) -> void:
	if Enums.is_a_polluting_building(building.building_type):
		buildings_polluting.set(building, building.position)
		building.emitted_emissions.connect(apply_emissions)

## Function to apply emissions emitted by a building
func apply_emissions(building: Building, emission_type: Enums.ResourceType, amount: float) -> void:
	var building_pos: Vector2 = buildings_polluting.get(building)
	var emissions_radius: int = building.building_data.emissions_radius.get(emission_type)
	emissions_to_apply.emit(emissions_falloff(amount, emissions_radius, building_pos, emission_type), emission_type)
	
## Function to calculate the emissions emitted in the area around the building
func emissions_falloff(amount: float, emissions_radius: int, building_pos: Vector2, emission_type: Enums.ResourceType) -> Dictionary[Vector2, float]:
	var emissions_dict: Dictionary[Vector2, float] = {}  
	var grid_size: int = 32
	## Iterate around the 2D area centered on the building,
	## where the area is determined by the emissions radius
	for x in range(-emissions_radius, emissions_radius + 1):
		for y in range(-emissions_radius, emissions_radius + 1):
			## Manhattan distance, grid based
			var distance_from_building: int = abs(x) + abs(y)
			
			## If outside the emissions radius
			if distance_from_building > emissions_radius:
				continue
				
			var tile_pos = building_pos + Vector2(x * grid_size, y * grid_size)

			## An exponential emission falloff
			var amount_to_set: float = amount * exp(float(-distance_from_building) / emissions_radius)
			
			## No negative amounts to set
			amount_to_set = max(amount_to_set, 0)
			emissions_dict.set(tile_pos, amount_to_set)
			set_emissions_generated(emission_type, amount_to_set)

	return emissions_dict

## Function to set the amount of emissions generated
func set_emissions_generated(emission_type: Enums.ResourceType, amount: float) -> void:
	var current_amount: float = emissions_generated.get(emission_type)
	emissions_generated.set(emission_type, amount + current_amount)

## Function to set the amount of emissions absorbed by other objects
func set_emissions_absorbed(emission_type: Enums.ResourceType, amount: float) -> void:
	var current_amount: float = emissions_absorbed.get(emission_type)
	emissions_absorbed.set(emission_type, amount + current_amount)
	
## Function to get the amount of emissions not absorbed by other objects
func get_emissions_not_absorbed(emission_type: Enums.ResourceType) -> float:
	var emissions_generated: float = emissions_generated.get(emission_type)
	var emissions_absorbed: float = emissions_absorbed.get(emission_type)
	return emissions_generated - emissions_absorbed
