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
	ResourceType.OIL: "res://assets/UI/Resource UI/crude_oil_resource.png",
	ResourceType.SAND: "res://assets/UI/Resource UI/sand_resource.png",
	ResourceType.WATER: "res://assets/UI/Resource UI/water_resource.png",
	ResourceType.FUEL: "res://assets/UI/Resource UI/fuel_resource.png",
	ResourceType.PLASTICS: "res://assets/UI/Resource UI/plastics_resource.png",
	ResourceType.GLASS: "res://assets/UI/Resource UI/glass_sheets_resource.png",
	ResourceType.ELECTRONICS: "res://assets/UI/Resource UI/circuit_board_resource.png",
	ResourceType.URANIUM: "res://assets/UI/Resource UI/uranium_resource.png",
	ResourceType.TOOLS: "res://assets/UI/Resource UI/",
	ResourceType.ENGINE: "res://assets/UI/Resource UI/engine_resource.png",
	ResourceType.COPPER_ORE: "res://assets/UI/Resource UI/copper_ore_resource.png",
	ResourceType.COPPER_BARS: "res://assets/UI/Resource UI/copper_bars_resource.png",
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
		ResourceType.OIL: "OIL",
		ResourceType.SAND: "SAND",
		ResourceType.WATER: "WATER",
		ResourceType.FUEL: "FUEL",
		ResourceType.PLASTICS: "PLASTICS",
		ResourceType.GLASS: "GLASS",
		ResourceType.ELECTRONICS: "ELECTRONICS",
		ResourceType.URANIUM: "URANIUM",
		ResourceType.TOOLS: "TOOLS",
		ResourceType.ENGINE: "ENGINE",
		ResourceType.COPPER_ORE: "COPPER ORE",
		ResourceType.COPPER_BARS: "COPPER BARS",
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
		"OIL": ResourceType.OIL,
		"SAND": ResourceType.SAND,
		"WATER": ResourceType.WATER,
		"FUEL": ResourceType.FUEL,
		"PLASTICS": ResourceType.PLASTICS,
		"GLASS": ResourceType.GLASS,
		"ELECTRONICS": ResourceType.ELECTRONICS,
		"URANIUM": ResourceType.URANIUM,
		"TOOLS": ResourceType.TOOLS,
		"ENGINE": ResourceType.ENGINE,
		"COPPER ORE": ResourceType.COPPER_ORE,
		"COPPER BARS": ResourceType.COPPER_BARS,
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
	BuildingType.OIL_RIG: "OIL RIG",
	BuildingType.SAND_COLLECTOR: "SAND COLLECTOR",
	BuildingType.WATER_PUMP: "WATER PUMP",
	BuildingType.OIL_REFINERY: "OIL REFINERY",
	BuildingType.GLASSWORKS: "GLASSWORKS",
	BuildingType.ELECTRONICS_FACTORY: "ELECTRONICS FACTORY",
	BuildingType.SOLAR_PLANT: "SOLAR PLANT",
	BuildingType.WIND_TURBINE: "WIND TURBINE",
	BuildingType.NUCLEAR_PLANT: "NUCLEAR PLANT",
	BuildingType.ROCKET_LAUNCHPAD: "ROCKET LAUNCHPAD",
	BuildingType.URANIUM_MINE: "URANIUM MINE",
	BuildingType.TOOL_FACTORY: "TOOL FACTORY",
	BuildingType.OIL_POWER_PLANT: "OIL POWER PLANT",
	BuildingType.ENGINE_FACTORY: "ENGINE FACTORY",
	BuildingType.COPPER_MINE: "COPPER MINE",
	BuildingType.COPPER_SMELTERY: "COPPER SMELTERY",
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
	ResourceType.SAND: 1,
	ResourceType.WATER: 2,
	ResourceType.OIL: 12,
	ResourceType.PLASTICS: 30,
	ResourceType.FUEL: 40,
	ResourceType.ELECTRONICS: 80,
	ResourceType.GLASS: 5,
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

## The different modes a productionbuilding can be in
enum ProductionBuildingMode {
	NULL,
	SELLING,
	STORING,
	PAUSED
}

static var mode_names: Dictionary[ProductionBuildingMode, String] = {
	ProductionBuildingMode.SELLING: "Selling",
	ProductionBuildingMode.STORING: "Storing",
	ProductionBuildingMode.PAUSED: "Paused",
	ProductionBuildingMode.NULL: "None"
}

static func mode_to_string(mode: ProductionBuildingMode) -> String:
	return mode_names.get(mode)

## The different types of resources in the game
enum ResourceType {
	IRON_ORE, ## The resource type for iron ore #0 in list
	COAL, ## The resource type for coal
	WOOD, ## The resource type for wood
	CO2, ## The resource type for carbon dioxide
	S02, ## The resource type for sulfur dioxide
	ELECTRICITY, ## The resource type for electricity #5 in list
	BIOMASS, ## The resource type for biomass
	N0X, ## The resource type for nitrogen oxides
	CH4, ## The resource type for methane
	NONE, ## The resource type for nothing
	PLANKS, ## The resource type for planks #10 in list
	STEEL, ## The resource type for steel
	GEARS, ## The resource type for gears
	STEEL_SCRAP, ## The resource type for STEEL SCRAP
	OIL, ## The resource type for crude oil
	SAND, ## The resource type for sand #15 in list
	WATER, ## The resource type for water droplet
	FUEL, ## The resource type for fuel
	PLASTICS, ## The resource type for plastics
	GLASS, ## The resource type for glass
	ELECTRONICS, ## The resource type for electronics #20 in list
	URANIUM, ## The resource type for uranium
	TOOLS, ## The resource type for tools
	ENGINE, ## The resource type for engine
	COPPER_ORE, ## The resource type for copper ore
	COPPER_BARS, ## The resource type for copper bars #25 in list
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
	STEEL_SCRAP_LANDFILL, ## The building type for a steel scrap landfill,
	OIL_RIG, ## The building type for an oil rig
	SAND_COLLECTOR, ## The building type for a sand collector
	WATER_PUMP, ## The building type for a water pump
	OIL_REFINERY, ## The building type for an oil refinery
	GLASSWORKS, ## The building type for a glassworks
	ELECTRONICS_FACTORY, ## The building type for an electronics factory
	SOLAR_PLANT, ## The building type for a solar plant
	WIND_TURBINE, ## The building type for a wind turbine
	NUCLEAR_PLANT, ## The building type for a nuclear plant
	ROCKET_LAUNCHPAD, ## The building type for a rocket launchpad
	URANIUM_MINE, ## The building type for a uranium mine
	TOOL_FACTORY, ## The building type for a tool factory
	OIL_POWER_PLANT, ## The building type for an oil power plant
	ENGINE_FACTORY, ## The building type for an engine factory
	COPPER_MINE, ## The building type for a copper mine
	COPPER_SMELTERY, ## The building type for a copper smeltery
}

static var building_data: Dictionary[BuildingType, Resource] = {
	BuildingType.IRON_MINE: load("res://resources/buildings/iron_mine.tres"),
	BuildingType.COAL_MINE: load("res://resources/buildings/coal_mine.tres"), 
	BuildingType.WOOD_CUTTER: load("res://resources/buildings/wood_cutter.tres"), 
	BuildingType.COAL_POWER_PLANT: load("res://resources/buildings/coal_power_plant.tres"), 
	BuildingType.BIOMASS_POWER_PLANT: load("res://resources/buildings/biomass_power_plant.tres"), 
	BuildingType.BIOMASS_LANDFILL: load("res://resources/buildings/biomass_landfill.tres"), 
	BuildingType.WAREHOUSE: load("res://resources/buildings/warehouse.tres"), 
	BuildingType.ROAD: load("res://resources/buildings/road.tres"), 
	BuildingType.SAW_MILL: load("res://resources/buildings/saw_mill.tres"),
	BuildingType.STEEL_MILL: load("res://resources/buildings/steel_mill.tres"),
	BuildingType.GEAR_FACTORY: load("res://resources/buildings/gear_factory.tres"),
	BuildingType.RESEARCH_LAB: load("res://resources/buildings/research_lab.tres"),
	BuildingType.STEEL_SCRAP_LANDFILL: load("res://resources/buildings/steel_scrap_landfill.tres"),
	BuildingType.OIL_RIG: load("res://resources/buildings/oil_rig.tres"), 
	BuildingType.SAND_COLLECTOR: load("res://resources/buildings/sand_collector.tres"),
	BuildingType.WATER_PUMP: load("res://resources/buildings/water_pump.tres"),
	BuildingType.OIL_REFINERY: load("res://resources/buildings/oil_refinery.tres"),
	BuildingType.GLASSWORKS: load("res://resources/buildings/glassworks.tres"), 
	BuildingType.ELECTRONICS_FACTORY: load("res://resources/buildings/electronics_factory.tres"), 
	BuildingType.SOLAR_PLANT: load("res://resources/buildings/solar_plant.tres"), 
	BuildingType.WIND_TURBINE: load("res://resources/buildings/solar_plant.tres"),
	BuildingType.NUCLEAR_PLANT: load("res://resources/buildings/nuclear_plant.tres"),
	#BuildingType.ROCKET_LAUNCHPAD: load("rocket"), ## To be added when Noel makes a rocket building
	#BuildingType.URANIUM_MINE: load(), ## There is currently no building data for a uranium mine
	#BuildingType.TOOL_FACTORY: load(), ## There is currently no tool factory
	#BuildingType.OIL_POWER_PLANT: load(oil_po), ## There is currently no data for oil power plant
	#BuildingType.ENGINE_FACTORY: load(), ## There is no data 
	#BuildingType.COPPER_MINE: load(copper), ## No data
	##BuildingType.COPPER_SMELTERY, ## No data
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
	ResourceType.N0X: "N0X",
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

## The possible research IDs
enum ResearchID {
	SM_1, ## Steel mill upgrade
	WC_1, ## Wood cutter upgrade
	CM_1, ## Coal mine upgrade
	IM_1, ## Iron mine upgrade
	SM_0, ## Steel mill unlock
	SwM_0, ## Saw mill unlock
	GF_0, ## Gear factory unlock
	BMPP_0, ## Biomass power plant unlock
	TE, ## Total emissions statistics
	WE, ## Wildfire emissions statistics
	SE, ## Smog emissions statistics
}

static var building_research: Dictionary[BuildingType, Array] = {
	BuildingType.STEEL_MILL: [ResearchID.SM_1, ResearchID.SM_0],
	BuildingType.WOOD_CUTTER: [ResearchID.WC_1],
	BuildingType.COAL_MINE: [ResearchID.CM_1],
	BuildingType.IRON_MINE: [ResearchID.IM_1],
	BuildingType.GEAR_FACTORY: [ResearchID.GF_0],
	BuildingType.BIOMASS_POWER_PLANT: [ResearchID.BMPP_0]
}

static var tree_size_multiplier_quantity: Dictionary[Enums.TreeSize, float] = {
	TreeSize.SMALL: 0.5,
	TreeSize.MEDIUM: 1.0,
	TreeSize.LARGE: 1.5,
}

static var tree_size_multiplier_pollution: Dictionary[Enums.TreeSize, float] = {
	TreeSize.SMALL: 0.8,
	TreeSize.MEDIUM: 1.0,
	TreeSize.LARGE: 1.2,
}

## The possible tree sizes
enum TreeSize {
	SMALL,
	MEDIUM,
	LARGE,
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
