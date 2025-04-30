class_name Enums
## A class that contains all the enums available
##
## A class that contains all the enums available, making it easier to access
## the enums globally accross scripts.
##

static var polluting_buildings: Array[BuildingType] = [
		BuildingType.COAL_MINE, BuildingType.IRON_MINE, 
		BuildingType.COAL_POWER_PLANT, BuildingType.BIOMASS_POWER_PLANT, 
		BuildingType.STEEL_MILL, BuildingType.GEAR_FACTORY,
		BuildingType.SAW_MILL
		]
		
static var byproducts: Array[ResourceType] = [ResourceType.CO2, ResourceType.BIOMASS, ResourceType.S02, ResourceType.N0X, ResourceType.CH4, ResourceType.STEEL_SCRAP]

static var emissions: Array[ResourceType] = [ResourceType.CO2, ResourceType.S02, ResourceType.N0X, ResourceType.CH4]

static var produced_good: Array[ResourceType] = [ResourceType.IRON_ORE, 
	ResourceType.COAL, ResourceType.ELECTRICITY, ResourceType.WOOD, 
	ResourceType.STEEL, ResourceType.PLANKS, ResourceType.GEARS]

static var landfills: Array[BuildingType] = [BuildingType.BIOMASS_LANDFILL, BuildingType.STEEL_SCRAP_LANDFILL]

static var resource_image_paths: Dictionary[ResourceType, String] = {
	ResourceType.IRON_ORE: "res://assets/UI/Resource UI/iron.tres",
	ResourceType.COAL: "res://assets/UI/Resource UI/coal.tres",
	ResourceType.WOOD: "res://assets/UI/Resource UI/wood.tres",
	ResourceType.ELECTRICITY: "res://assets/UI/Resource UI/electricity.png",
	ResourceType.BIOMASS: "res://assets/UI/Resource UI/biomass.png",
	ResourceType.STEEL: "res://assets/UI/Resource UI/steel_resource.png",
	ResourceType.PLANKS: "res://assets/UI/Resource UI/planks_resource.png",
	ResourceType.GEARS: "res://assets/UI/Resource UI/gears_resource.png",
	ResourceType.STEEL_SCRAP: "res://assets/UI/Resource UI/steel_scrap.png",
}

static var resource_names_type_to_string: Dictionary[ResourceType, String] = {
		ResourceType.IRON_ORE: "IRON ORE",
		ResourceType.COAL: "COAL",
		ResourceType.WOOD: "WOOD",
		ResourceType.PLANKS: "PLANKS",
		ResourceType.STEEL: "STEEL",
		ResourceType.GEARS: "GEARS",
		ResourceType.STEEL_SCRAP: "STEEL SCRAP",
		ResourceType.CO2: "CO2",
		ResourceType.S02: "SO2",
		ResourceType.ELECTRICITY: "ELECTRICITY",
		ResourceType.BIOMASS: "BIOMASS",
		ResourceType.N0X: "N0X",
		ResourceType.CH4: "CH4",
		ResourceType.NONE: "NONE",
	}	
	
static var resource_names_string_to_type: Dictionary[String, ResourceType] = {
		"IRON ORE": ResourceType.IRON_ORE,
		"COAL": ResourceType.COAL,
		"WOOD": ResourceType.WOOD,
		"PLANKS": ResourceType.PLANKS,
		"STEEL": ResourceType.STEEL,
		"GEARS": ResourceType.GEARS,
		"STEEL SCRAP": ResourceType.STEEL_SCRAP,
		"CO2": ResourceType.CO2,
		"SO2": ResourceType.S02,
		"ELECTRICITY": ResourceType.ELECTRICITY,
		"BIOMASS": ResourceType.BIOMASS,
		"N0X": ResourceType.N0X,
		"CH4": ResourceType.CH4,
		"NONE": ResourceType.NONE,
	}

static var building_names: Dictionary[BuildingType, String] = {
	BuildingType.FACTORY: "FACTORY",
	BuildingType.IRON_MINE: "IRON MINE",
	BuildingType.COAL_MINE: "COAL MINE",
	BuildingType.WOOD_CUTTER: "WOOD CUTTER",
	BuildingType.COAL_POWER_PLANT: "COAL POWER PLANT",
	BuildingType.BIOMASS_POWER_PLANT: "BIOMASS POWER PLANT",
	BuildingType.BIOMASS_LANDFILL: "BIOMASS LANDFILL",
	BuildingType.WAREHOUSE: "WAREHOUSE",
	BuildingType.ROAD: "ROAD",
	BuildingType.SAW_MILL: "SAW MILL",
	BuildingType.STEEL_MILL: "STEEL MILL",
	BuildingType.GEAR_FACTORY: "GEAR FACTORY",
	BuildingType.RESEARCH_LAB: "RESEARCH LAB",
	BuildingType.STEEL_SCRAP_LANDFILL: "STEEL SCRAP LANDFILL",
	}
	
static var warehouses: Dictionary[BuildingType, String] = {
	BuildingType.BIOMASS_LANDFILL: "BIOMASS LANDFILL",
	BuildingType.WAREHOUSE: "WAREHOUSE",
	BuildingType.STEEL_SCRAP_LANDFILL: "STEEL SCRAP LANDFILL",
	}

static var tile_names: Dictionary[TileType, String] = {
	TileType.WATER: "WATER",
	TileType.DIRT: "DIRT",
	TileType.STONE: "STONE",
	TileType.GRASS: "GRASS",
	TileType.RESOURCE: "RESOURCE",
	}
# List of the value of every resource when sold
static var resource_costs: Dictionary[ResourceType, int] = {
	ResourceType.IRON_ORE: 2,
	ResourceType.COAL: 3,
	ResourceType.WOOD: 5,
	ResourceType.ELECTRICITY: 10,
	ResourceType.STEEL: 10,
	ResourceType.PLANKS: 16,
	ResourceType.GEARS: 20,
}

static var emissions_contributing_to_wildfires: Dictionary[ResourceType, String] = {
	ResourceType.CO2: "CO2",
	ResourceType.N0X: "N0X",
	ResourceType.CH4: "CH4",
}
## TEMPORARY
static var emissions_contributing_to_smog: Dictionary[ResourceType, String] = {
	ResourceType.S02: "S02",
	ResourceType.N0X: "N0X",
}

## Function that returns the value of a resource when sold
static func get_value_of_resource(resource: ResourceType) -> int:
	return resource_costs.get(resource)
	
static func get_value_of_resources(resource: ResourceType, amount: int) -> int:
	return resource_costs.get(resource)*amount

## The different types of resources in the game
enum ResourceType {
	IRON_ORE, ## The resource type for iron ore
	COAL, ## The resource type for coal
	WOOD, ## The resource type for wood
	CO2, ## The resource type for carbon dioxide
	S02, ## The resource type for sulfur dioxide
	ELECTRICITY, ## The resource type for electricity
	BIOMASS, ## The resource type for biomass
	N0X, ## The resource type for nitrogen oxides
	CH4, ## The resource type for methane
	NONE, ## The resource type for nothing
	PLANKS, ## The resource type for planks
	STEEL, ## The resource type for steel
	GEARS, ## The resource type for gears
	STEEL_SCRAP, ## The resource type for STEEL SCRAP
}

## The different types of buildings in the game
# Factory and gathering building are just temporary names?
enum BuildingType {
	FACTORY, ## The building type for a test factory
	IRON_MINE, ## The building type for an iron mine
	COAL_MINE, ## The building type for a coal mine
	WOOD_CUTTER, ## The building type for a wood cutter
	COAL_POWER_PLANT, ## The building type for a coal power plant
	BIOMASS_POWER_PLANT, ## The building type for a biomass power plant
	BIOMASS_LANDFILL, ## The building type for a biomass landfill
	WAREHOUSE, ## The building type for a warehouse
	ROAD, ## The building type for roads
	SAW_MILL, ## The building type for a saw mill 
	STEEL_MILL, ## The building type for a steel mill 
	GEAR_FACTORY, ## The building type for a gear factory
	RESEARCH_LAB, ## The building type for a research lab
	STEEL_SCRAP_LANDFILL ## The building type for a STEEL SCRAP landfill,
}
## Function for checking if the BuildingType is a gathering building
static func is_gathering_building(building_type: BuildingType) -> bool:
	var gathering_buildings: Array[BuildingType] = [BuildingType.IRON_MINE, BuildingType.COAL_MINE, BuildingType.WOOD_CUTTER]
	return building_type in gathering_buildings
	
## Function for checking if the BuildingType is a power generator
static func is_power_generator(building_type: BuildingType) -> bool:
	var power_generators: Array[BuildingType] = [BuildingType.COAL_POWER_PLANT, BuildingType.BIOMASS_POWER_PLANT]
	return building_type in power_generators

## The different types of tiles in the game
enum TileType {
	WATER, ## The tile type for water
	DIRT, ## The tile type for dirt
	STONE, ## The tile type for stone
	GRASS, ## The tile type for grass
	RESOURCE, ## The tile type for a resource
}

## The different types of pollution
enum PollutionLevel {
	NORMAL,
	SLIGHTLY,
	HEAVILY,
	DEAD,
}

static var emissions_contributing_to_tree_pollution: Dictionary[ResourceType, String] = {
	ResourceType.S02: "S02",
}
static func is_a_tree_pollution_contributor(resource_type: ResourceType) -> bool:
	return resource_type in emissions_contributing_to_tree_pollution
	
## The different states of burning
enum BurnState { 
	NORMAL, ## The state when not having been burned previously
	BURNING, 
	DEAD 
}
	
## The possible directions
enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

static func is_a_polluting_building(building_type: BuildingType) -> bool:
	return building_type in polluting_buildings
	
static func is_warehouse(building_type: Enums.BuildingType) -> bool:
	return building_type in warehouses

## Function for checking if the ResourceType is a byproduct
static func is_byproduct(resource_type: ResourceType) -> bool:
	return resource_type in byproducts

## Function for checking if the ResourceType is an emission
static func is_emission(resource_type: ResourceType) -> bool:
	return resource_type in emissions
	
## Function for checking if the ResourceType is a produced good
static func is_produced_good(resource_type: ResourceType) -> bool:
	return resource_type in produced_good

## Function for returning the string equivalent of a ResourceType
static func resource_type_to_string(resource_type: ResourceType) -> String:
	## Default to "UNKNOWN" if not found
	return resource_names_type_to_string.get(resource_type, -1)  
	
## Function for returning the ResourceType equivalent of a string	
static func string_to_resource_type(string: String) -> ResourceType:
	return resource_names_string_to_type.get(string, -1)  
	
## Function for returning the string equivalent of a BuildingType
static func building_type_to_string(building_type: BuildingType) -> String:
	return building_names.get(building_type, "UNKNOWN") 

## Function for returning the string equivalent of a TileType
static func tile_type_to_string(tile_type: TileType) -> String:
	return tile_names.get(tile_type, "UNKNOWN") 
