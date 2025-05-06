class_name SteelMill
extends ProductionBuilding
## A class that is for the aspects of a steel mill.
##
## A class that is for the aspects of a steel mill. This class extends from
## the ProductionBuilding class.
##

func _ready():
	super()

func apply_research_upgrade(research_data: ResearchData) -> void:
	if research_data.id == Enums.ResearchID.SM_1:
		var input_array: Array[Enums.ResourceType] = [Enums.ResourceType.ELECTRICITY, Enums.ResourceType.STEEL_SCRAP]
		var new_input_recipe: InputRecipe = InputRecipe.new()

		input_recipes.set(1, new_input_recipe)

		new_input_recipe.resources = input_array
		max_storage.set(Enums.ResourceType.STEEL_SCRAP, 60)
		input_storage.set(Enums.ResourceType.STEEL_SCRAP, 60)
		input_use_rates.set(Enums.ResourceType.STEEL_SCRAP, 60)
		
