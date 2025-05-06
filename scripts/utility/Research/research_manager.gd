class_name ResearchManager
extends Node

# Signal sent when research is completed
signal research_completed(research_id: Enums.ResearchID)

@onready var player_resources: PlayerResources = $"../PlayerResources"

## A list storing the IDs of completed research 
var completed_research: Array[Enums.ResearchID] = []

func _ready() -> void:
	ResearchSignals.research_clicked.connect(complete_research)

## Function for completing research
func complete_research(research_data: ResearchData) -> void:
	## Checking
	if has_completed(research_data):
		return
		
	if research_data.money_cost:
		if PlayerCurrency.player_held_currency < research_data.money_cost:
			return
		
	if research_data.resource_cost:
		for resource in research_data.resource_cost.keys():
			if player_resources.resources.has(resource):
				var current_amount: int = player_resources.resources.get(resource)
				var amount_needed: int = research_data.resource_cost.get(resource)
				if current_amount < amount_needed:
					return
			else:
				return
	
	for resource in research_data.resource_cost.keys():
		var current_amount: int = player_resources.resources.get(resource)
		var amount_needed: int = research_data.resource_cost.get(resource)
		player_resources.buy_with_resources(resource, amount_needed)
			
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
