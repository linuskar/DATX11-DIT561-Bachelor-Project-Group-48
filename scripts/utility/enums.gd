class_name Enums
## A class that contains all the enums available
##
## A class that contains all the enums available, making it easier to access
## the enums globally accross scripts.
##

## The different types of buildings in the game
# Factory and gathering building are just temporary names?
enum BuildingType {FACTORY, IRON_MINE, COAL_MINE, WOOD_CUTTER}

## The different types of resources in the game
enum ResourceType {IRON_ORE, COAL, WOOD, CO2, NONE}

static func is_emission(resource_type: ResourceType) -> bool:
	var emissions: Array[ResourceType] = [ResourceType.CO2]
	return resource_type in emissions

static func is_produced_good(resource_type: ResourceType) -> bool:
	var emissions: Array[ResourceType] = [ResourceType.IRON_ORE, ResourceType.COAL, ResourceType.WOOD]
	return resource_type in emissions

## Function for retuning the string equivalent of a resource type
static func resource_type_to_string(resource_type: ResourceType) -> String:
	var resource_names = {
		ResourceType.IRON_ORE: "IRON ORE",
		ResourceType.COAL: "COAL",
		ResourceType.WOOD: "WOOD",
		ResourceType.NONE: "NONE",
	}
	## Default to "UNKNOWN" if not found
	return resource_names.get(resource_type, "UNKNOWN")  
	
## Function for retuning the string equivalent of a building type
static func buiilding_type_to_string(building_type: BuildingType) -> String:
	var building_names = {
		BuildingType.FACTORY: "FACTORY",
		BuildingType.IRON_MINE: "IRON MINE",
		BuildingType.COAL_MINE: "COAL MINE",
		BuildingType.WOOD_CUTTER: "WOOD CUTTER",
	}
	return building_names.get(building_type, "UNKNOWN") 
