extends UIMenu

@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer

var available_research: Array[ResearchData] = [
	load("res://resources/research_data/CoalMineUpgrade1.tres"),
	load("res://resources/research_data/steel_mill_upgrade1.tres"),
	load("res://resources/research_data/WoodCutterUpgrade1.tres"),
]
var research_lab_selected: ResearchLab = null
var research_entry_scene: PackedScene = preload("res://scenes/UI/ResearchUI/Research_Entry.tscn")
var research_entries: Array[ResearchEntry]

func _ready() -> void:
	super()
	
	for research in available_research:
		var research_entry: ResearchEntry = research_entry_scene.instantiate()
		research_entry.research_data = research
		research_entries.append(research_entry)
		v_box_container.add_child(research_entry)
	
	hide()

#Open UI
func open(research_lab_clicked: ResearchLab) -> void:
	research_lab_selected = research_lab_clicked
	research_lab_selected.currently_selected = true
	show()

#Close UI
func close() -> void:
	research_lab_selected.currently_selected = false
	hide()
