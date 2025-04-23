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
@onready var wildfire_timer: Timer = $WildfireTimer
@onready var emission_decay_timer: Timer = $EmissionDecayTimer
@onready var user_interface: UserInterface = $"../UserInterface"

## The buildings that are polluting
var buildings_polluting: Dictionary[Building, Vector2]

## Signal for the emissions that need to be applied
signal emissions_to_apply(emissions_dict: Dictionary[Vector2, float], emission_type: Enums.ResourceType)

## Dictionary for the total emissions generated 
var emissions_generated: Dictionary[Enums.ResourceType, float]
## Dictionary for the total emissions absorbed by other objects 
var emissions_absorbed: Dictionary[Enums.ResourceType, float]
## Dictionary for the total emissions not absorbed by other objects 
var emissions_not_absorbed: Dictionary[Enums.ResourceType, float] = {}

## The percentage of when a wildfire could start
var wildfire_start_percentage: float = 0.0
## The wait time between wildfires happening, to avoid wildfires being spammed
## as the game is running
var wildfire_wait_time: float = 1.0
## The upper limit for the amount of emissions that can exist in the game
var emission_upper_limit: float = pow(10,7)

## Emissions decay by 1% of their total value
var emission_decay: float = 0.01
## The wait itme between emissions decaying
var emission_decay_wait_time: float = 1.0

## The minimum probability for a fire to spread to a tree
var min_fire_spread_probability: float = 0.4 
## The maximum probability for a fire to spread to a tree
var max_fire_spread_probability: float = 0.6

## The current probability for a fire to spread
var fire_spread_prob: float = 0.0

var warning_indicator_scene = preload("res://scenes/UI/warning_indicator.tscn")
var current_warning_indicator: WarningIndicator = null

func _ready() -> void:
	for emission in Enums.emissions:
		emissions_generated.set(emission, 0)
		emissions_absorbed.set(emission, 0)
		emissions_not_absorbed.set(emission, 0)
	
	build_manager.placed_building.connect(_init_building_polluting)
	wildfire_timer.wait_time = wildfire_wait_time
	emission_decay_wait_time = emission_decay_wait_time
	
## Function that decays emissions based on a time delay
func _on_emission_decay_timer_timeout() -> void:
	for emission in emissions_generated.keys():
		var emission_amount: float = emissions_not_absorbed.get(emission)
		emission_amount -= emission_amount * emission_decay
		## Prevent the amount to be below 0, a negative value
		emission_amount = max(0, emission_amount)
		emissions_not_absorbed.set(emission, emission_amount)

## Function to try to start a wildfire based on a time delay
func _on_wildfire_timer_timeout() -> void:
	if check_for_wildfire():
		return 
		
	update_wildfire_percentage()
	start_wildfire()

## Function to check if there is a ongoing wildfire
func check_for_wildfire() -> bool:
	var all_trees: Array[Node] = get_tree().get_nodes_in_group("trees")
	var trees_burning: Array[Node] = []
	for tree in all_trees:
		if tree.burn_state == Enums.BurnState.BURNING:
			trees_burning.append(tree)
			
	if trees_burning.size() == 0:
		if current_warning_indicator != null:
			current_warning_indicator.queue_free()
		return false
	else:
		return true
		
## Function that updates the probability for a wildfire to happen and
## the severity, to imitate how dry it is which increases the fire spread
func update_wildfire_percentage() -> void:
	var emission_amount: float = 0.0
	wildfire_start_percentage = 0.0
	fire_spread_prob = 0.0
	
	for emission in Enums.emissions_contributing_to_wildfires:
		var emission_not_absorbed: float = emissions_not_absorbed.get(emission)
		emission_amount += min(emission_not_absorbed, emission_upper_limit)
		
	## Normalize, scale the value to range from 0 to 1
	var emission_norm: float = inverse_lerp(0.0, emission_upper_limit, emission_amount)
	wildfire_start_percentage = emission_norm
	
	var emission_amount_fire_spread_prob_scaled: float = lerp(min_fire_spread_probability, max_fire_spread_probability, emission_norm)
	fire_spread_prob = emission_amount_fire_spread_prob_scaled
	
## Function to start a wildfire, starting on a random tree
func start_wildfire() -> void:
	var random_number: float = randf()

	if random_number <= wildfire_start_percentage:
		var all_trees: Array[Node] = get_tree().get_nodes_in_group("trees")
		var random_index: int = randi_range(0, all_trees.size()-1)
		var random_tree: GatherableTree = all_trees[random_index]
		
		random_tree.start_burning(fire_spread_prob)
		
		current_warning_indicator = warning_indicator_scene.instantiate()
		current_warning_indicator.position = random_tree.position
		current_warning_indicator.top_y_offset = user_interface.panel_container.size.y
		
		get_parent().add_child(current_warning_indicator)

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
			set_emissions_not_absorbed(emission_type, amount_to_set)
			
	return emissions_dict

## Function to set the amount of emissions generated
func set_emissions_generated(emission_type: Enums.ResourceType, amount: float) -> void:
	var current_amount: float = emissions_generated.get(emission_type)
	emissions_generated.set(emission_type, amount + current_amount)

## Function to set the amount of emissions absorbed by other objects
func set_emissions_absorbed(emission_type: Enums.ResourceType, amount: float) -> void:
	var current_amount: float = emissions_absorbed.get(emission_type)
	emissions_absorbed.set(emission_type, amount + current_amount)
	
## Function to set the amount of emissions not absorbed by other objects
func set_emissions_not_absorbed(emission_type: Enums.ResourceType, amount: float) -> void:
	var current_amount: float = emissions_not_absorbed.get(emission_type)
	emissions_not_absorbed.set(emission_type, current_amount + amount)
