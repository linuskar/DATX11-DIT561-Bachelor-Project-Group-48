class_name Enums
## A class that contains all the enums available
##
## A class that contains all the enums available, making it easier to access
## the enums globally accross scripts.
##

## The different types of buildings in the game
# Factory and gathering building are just temporary names?
enum BuildingType {FACTORY, GATHERING_BUILDING}

## The different types of resources in the game
enum ResourceType {IRON_ORE, COAL, WOOD, NONE}

static func resource_type_to_string(resource_type: ResourceType) -> String:
	var resource_names = {
		ResourceType.IRON_ORE: "IRON ORE",
		ResourceType.COAL: "COAL",
		ResourceType.WOOD: "WOOD",
		ResourceType.NONE: "NONE",
	}
	## Default to "UNKNOWN" if not found
	return resource_names.get(resource_type, "UNKNOWN")  

static func buiilding_type_to_string(building_type: BuildingType) -> String:
	var building_names = {
		BuildingType.FACTORY: "FACTORY",
		BuildingType.GATHERING_BUILDING: "GATHERING BUILDING",
	}
	return building_names.get(building_type, "UNKNOWN") 
