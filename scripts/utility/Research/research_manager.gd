class_name ResearchManager
extends Node

@onready var player_resources: PlayerResources = $"../PlayerResources"
@onready var research_complete_sound: AudioStreamPlayer2D = $ResearchCompleteSound

## A list storing the IDs of completed research 
var completed_research: Array[Enums.ResearchID] = []
var selected_research_lab: ResearchLab

func _ready() -> void:
	ResearchSignals.research_clicked.connect(complete_research)
	ResearchSignals.research_lab_selected.connect(set_research_lab)

func set_research_lab(research_lab: ResearchLab) -> void:
	selected_research_lab = research_lab

## Function for completing research
func complete_research(research_data: ResearchData) -> void:
	var lab_network: ResourceTransport = player_resources.get_network_for_building(selected_research_lab)
	
	if has_completed(research_data) or selected_research_lab == null or lab_network == null:
		return
		
	if research_data.resource_cost:
		for resource in research_data.resource_cost.keys():
			var amount_needed: int = research_data.resource_cost.get(resource)
			var amount_needed_is_stored: bool = player_resources.check_resource_amount_in_network(resource, amount_needed, lab_network)
			
			if not amount_needed_is_stored:
				return
	
	if research_data.money_cost:
		if PlayerCurrency.player_held_currency < research_data.money_cost:
			return
		
	for resource in research_data.resource_cost.keys():
		var current_amount: int = player_resources.resources.get(resource)
		var amount_needed: int = research_data.resource_cost.get(resource)
		player_resources.buy_with_resources(resource, amount_needed, lab_network.buildings)

	if research_data.money_cost:
		PlayerCurrency.player_held_currency -= research_data.money_cost
	
	update_data(research_data.research_id)
	completed_research.append(research_data.research_id)			# Add to the completed list
	ResearchSignals.research_completed.emit(research_data)
	research_complete_sound.position = selected_research_lab.position
	research_complete_sound.play(2.24)

# Function to check for already completed research 
# (Probably useful when you place a new building)
func has_completed(research_data: ResearchData) -> bool:
	return research_data.research_id in completed_research

func update_data(research_id: Enums.ResearchID) -> void:
	if research_id == Enums.ResearchID.SM_1:
		var data: ProductionBuildingData = Enums.building_data.get(Enums.BuildingType.STEEL_MILL)
		data.input_types.append(Enums.ResourceType.STEEL_SCRAP)
		data.input_use_rates.set(Enums.ResourceType.STEEL_SCRAP, 60)
		data.max_storage.set(Enums.ResourceType.STEEL_SCRAP, 60)
		
		var input_array: Array[Enums.ResourceType] = [Enums.ResourceType.ELECTRICITY, Enums.ResourceType.STEEL_SCRAP]
		var new_input_recipe: InputRecipe = InputRecipe.new()
		data.input_recipes.set(1, input_array)
	elif research_id == Enums.ResearchID.IM_1:
		var data: GatheringBuildingData = Enums.building_data.get(Enums.BuildingType.IRON_MINE)
		var iron_gather_rate: int = data.output_generation.get(Enums.ResourceType.IRON_ORE)
		data.output_generation.set(Enums.ResourceType.IRON_ORE, iron_gather_rate + 5)
	elif research_id == Enums.ResearchID.WC_1:
		var data: AreaGatheringBuildingData = Enums.building_data.get(Enums.BuildingType.WOOD_CUTTER)
		var wood_gather_rate: int = data.output_generation.get(Enums.ResourceType.WOOD)
		data.output_generation.set(Enums.ResourceType.WOOD, wood_gather_rate + 5)
	elif research_id == Enums.ResearchID.CM_1:
		var data: GatheringBuildingData = Enums.building_data.get(Enums.BuildingType.COAL_MINE)
		var coal_gather_rate: int = data.output_generation.get(Enums.ResourceType.COAL)
		data.output_generation.set(Enums.ResourceType.COAL, coal_gather_rate + 5)
