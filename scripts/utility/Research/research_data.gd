class_name ResearchData
extends Resource

@export var research_id: Enums.ResearchID         # unique identifier
@export var research_name: String       # A more user-friendly name
@export var description: String         # A description of what the research does.
@export var money_cost: int = 0
@export var resource_cost: Dictionary[Enums.ResourceType, int]

# idk maybe TODO: @export_file var icon_path: String
