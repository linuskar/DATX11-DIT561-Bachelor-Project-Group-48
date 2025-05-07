class_name ResearchManager
extends Node

# Signal sent when research is completed
signal research_completed(research_id: Enums.ResearchID)

@onready var player_resources: PlayerResources = $"../PlayerResources"

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
	if selected_research_lab == null:
		print("selected lab is null")
		return
		
	if has_completed(research_data):
		print("research is already completed")
		return
	
	if research_data.resource_cost:
		for resource in research_data.resource_cost.keys():
			var amount_needed: int = research_data.resource_cost.get(resource)
			var network: ResourceTransport = player_resources.get_network_for_building(selected_research_lab)
			var amount_needed_is_stored: bool = player_resources.check_resource_amount_in_network(resource, amount_needed, network)
			
			if not amount_needed_is_stored:
				print("missing resources in network")
				return
	
	if research_data.money_cost:
		if PlayerCurrency.player_held_currency < research_data.money_cost:
			print("money requirement not met")
			return
	
	for resource in research_data.resource_cost.keys():
		var current_amount: int = player_resources.resources.get(resource)
		var amount_needed: int = research_data.resource_cost.get(resource)
		#player_resources.buy_with_resources(resource, amount_needed, BuildManagerGlobal.get_all_storage_buildings())
		player_resources.buy_with_resources_in_network_with_research(resource, amount_needed, selected_research_lab)
	if research_data.money_cost:
		PlayerCurrency.player_held_currency -= research_data.money_cost
	
	update_data(research_data.research_id)
	completed_research.append(research_data.research_id)			# Add to the completed list
	ResearchSignals.research_completed.emit(research_data)

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
