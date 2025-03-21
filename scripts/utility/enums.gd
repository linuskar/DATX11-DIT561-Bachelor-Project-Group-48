class_name Enums
## A class that contains all the enums available
##
## A class that contains all the enums available, making it easier to access
## the enums globally accross scripts.
##

## The different types of buildings in the game
# Factory and gathering building are just temporary names?
enum BuildingType {
	FACTORY, ## The building type for a test factory
	IRON_MINE, ## The building type for an iron mine
	COAL_MINE, ## The building type for a coal mine
	WOOD_CUTTER, ## The building type for a wood cutter
}

## The different types of resources in the game
enum ResourceType {
	IRON_ORE, ## The resource type for iron ore
	COAL, ## The resource type for coal
	WOOD, ## The resource type for wood
	CO2, ## The resource type for carbon dioxide
	ELECTRICITY, ## The resource type for electricity
	NONE, ## The resource type for nothing
}

enum TileType {
	WATER,
	DIRT,
	STONE,
	GRASS,
	RESOURCE,
}

## Function for checking if the ResourceType is an emission
static func is_emission(resource_type: ResourceType) -> bool:
	var emissions: Array[ResourceType] = [ResourceType.CO2]
	return resource_type in emissions
	
## Function for checking if the ResourceType is a produced good
static func is_produced_good(resource_type: ResourceType) -> bool:
	var emissions: Array[ResourceType] = [ResourceType.IRON_ORE, 
	ResourceType.COAL, ResourceType.ELECTRICITY, ResourceType.WOOD]
	return resource_type in emissions

## Function for returning the string equivalent of a ResourceType
static func resource_type_to_string(resource_type: ResourceType) -> String:
	var resource_names: Dictionary[ResourceType, String] = {
		ResourceType.IRON_ORE: "IRON ORE",
		ResourceType.COAL: "COAL",
		ResourceType.WOOD: "WOOD",
		ResourceType.CO2: "CO2",
		ResourceType.ELECTRICITY: "ELECTRICITY",
		ResourceType.NONE: "NONE",
	}
	## Default to "UNKNOWN" if not found
	return resource_names.get(resource_type, "UNKNOWN")  
	
## Function for returning the string equivalent of a BuildingType
static func building_type_to_string(building_type: BuildingType) -> String:
	var building_names: Dictionary[BuildingType, String] = {
		BuildingType.FACTORY: "FACTORY",
		BuildingType.IRON_MINE: "IRON MINE",
		BuildingType.COAL_MINE: "COAL MINE",
		BuildingType.WOOD_CUTTER: "WOOD CUTTER",
	}
	return building_names.get(building_type, "UNKNOWN") 
