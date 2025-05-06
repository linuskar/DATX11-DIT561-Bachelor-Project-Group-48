extends Button
class_name ResearchEntry

var research_data: ResearchData

@onready var name_label: Label = $HBoxContainer/LeftContainer/VBoxContainer/Name
@onready var description_label: Label = $HBoxContainer/LeftContainer/VBoxContainer/Description
@onready var cost_label: Label = $HBoxContainer/LeftContainer/VBoxContainer/Cost

func _ready() -> void:
	if research_data:
		name_label.text = research_data.research_name
		description_label.text = research_data.description
		cost_label.text = "Cost: FREE"  # Placeholder

		#if Research.has_completed(research_data):
		#	disabled = true
		cost_label.text = "\nCost"
		
		if research_data.money_cost:
			cost_label.text += "\n" + str(research_data.money_cost) + "\n" 
		
		## TODO:
		if research_data.resource_cost:
			for resource in research_data.resource_cost.keys():
				var amount: String = str(research_data.resource_cost.get(resource))
				cost_label.text += "\n" + Enums.resource_type_to_string(resource) + ": " + amount + "\n"
		
		if research_data.money_cost == null and research_data.resource_cost == null:
			cost_label.text = "\nFREE\n"  
			
		#if Research.has_completed(research_data):
			#disabled = true

		connect("pressed", _on_pressed)
		ResearchSignals.research_completed.connect(disable_research_entry)

func disable_research_entry(research_data_to_check: ResearchData) -> void:
	if research_data == research_data_to_check:
		disabled = true

func _on_pressed() -> void:
	#if Research.has_completed(research_data.research_id):
	#	return

	#Research.complete_research(research_data.research_id)
	
	ResearchSignals.research_clicked.emit(research_data)
	disabled = true
