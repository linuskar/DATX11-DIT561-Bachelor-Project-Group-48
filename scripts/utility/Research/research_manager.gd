extends Node
class_name ResearchManager

# Signal sent when research is completed
signal research_completed(research_id: Enums.ResearchID)

# A list storing the IDs of completed research 
var completed_research: Array[Enums.ResearchID] = []

# Function for completing research
func complete_research(research_id: Enums.ResearchID) -> void:
	if completed_research.has(research_id):
		return
	update_data(research_id)
	completed_research.append(research_id)			# Add to the completed list
	research_completed.emit(research_id)

# Function to check for already completed research 
# (Probably useful when you place a new building)
func has_completed(research_id: Enums.ResearchID) -> bool:
	return research_id in completed_research

func update_data(research_id: Enums.ResearchID) -> void:
	if research_id == Enums.ResearchID.SM_1:
		var data: BuildingData = Enums.building_data.get(Enums.BuildingType.STEEL_MILL)
		data.input_types.append(Enums.ResourceType.STEEL_SCRAP)
		data.input_use_rates.set(Enums.ResourceType.STEEL_SCRAP, 60)
		data.max_storage.set(Enums.ResourceType.STEEL_SCRAP, 60)
		
		var input_array: Array[Enums.ResourceType] = [Enums.ResourceType.ELECTRICITY, Enums.ResourceType.STEEL_SCRAP]
		var new_input_recipe: InputRecipe = InputRecipe.new()
		data.input_recipes.set(1, input_array)
