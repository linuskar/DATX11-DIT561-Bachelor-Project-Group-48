class_name GatherableTree
extends GatherableResource
## A class representing a gatherable tree.
##
## A class representing a gatherable tree that can absorb emissions. This class
## extends the GatherableResource class.
##
##

var burn_state: Enums.BurnState = Enums.BurnState.NORMAL
var burn_time: float = 3.0 
var spread_radius: int = 32
## TODO: dryness factor increasing based on carbon emissions
var fire_probability: float = 0.4 

## Dictionary for the maximum capacity of emissions that can be stored.
## Set the max capacity to -1 to indicate it has unlmited max capacity
## for a resource.
@export var emission_max_capacity: Dictionary[Enums.ResourceType, float] = {}
## The current storage of emissions.
var emission_storage: Dictionary[Enums.ResourceType, float] = {}

@onready var sprite_2d: Sprite2D = $Sprite2D
var dead_tree_sprite: CompressedTexture2D = preload("res://assets/dead_tree.png")

## Sprite that gets shown when resource is gathered
@onready var gathering_sprite_2d: Sprite2D = $GatheringSprite2D
@onready var wildfire: WildFire = $Wildfire

func _ready() -> void:
	emission_storage.set(Enums.ResourceType.CO2, 0)
	emission_storage.set(Enums.ResourceType.S02, 0)
	wildfire.stop_fire()

## Function to ignite the tree on fire
func start_burning() -> void:
	if burn_state != Enums.BurnState.NORMAL:
		return
	
	burn_state = Enums.BurnState.BURNING
	update_burn_visual()
	become_burnt()
	
## Function to update the burn visuals of a tree
func update_burn_visual():
	match burn_state:
		Enums.BurnState.NORMAL:
			modulate = Color(1, 1, 1)
		Enums.BurnState.BURNING:
			wildfire.start_fire()
		Enums.BurnState.BURNT:
			wildfire.stop_fire()
			sprite_2d.region_enabled = false
			sprite_2d.texture = dead_tree_sprite

## Function to make the tree burnt and spread the fire 
func become_burnt() -> void:
	## Wait for a certain amount of time, spread the fire and then become burnt
	await get_tree().create_timer(burn_time).timeout
	spread_fire()

	burn_state = Enums.BurnState.BURNT
	update_burn_visual()
	quantity = 0
	
## Function to spread the fire to nearby trees in range
func spread_fire():
	var nearby_trees: Array[Node] = get_tree().get_nodes_in_group("trees")
	for tree in nearby_trees:
		## Don't spread fire to itself
		if tree == self:
			continue
		## Tree in range
		if position.distance_to(tree.position) <= spread_radius:
			## Start burning trees that have not been burned before,
			## based on a probability for a fire to start
			if tree.burn_state == Enums.BurnState.NORMAL and randf() <= fire_probability:
				tree.start_burning()

## Function to check if the stored emissions are at or above the 
## max capacity that is allowed.
func check_if_at_emission_limit() -> bool:
	for emission_type in emission_storage.keys():	
		var emission_stored: float = emission_storage.get(emission_type)
		var emission_limit = emission_max_capacity.get(emission_type)
		## Destroy the tree if the limit for sulfur dioxide is reached
		if emission_stored >= emission_limit and emission_type == Enums.ResourceType.S02:
			queue_free()
			return true
	return false

## Function to absorb emissions.
func absorb_emission(emission_type: Enums.ResourceType, amount: float):
	if burn_state == Enums.BurnState.NORMAL:
		var amount_to_set: float = amount + emission_storage.get(emission_type)
		emission_storage.set(emission_type, amount_to_set)
