extends UIMenu

@onready var research_container: VBoxContainer = $List/PanelContainer/Research/ResearchContainer
@onready var statistics_container: VBoxContainer = $List/PanelContainer/Statistics/StatisticsContainer

@onready var tab_bar: TabBar = $PanelContainer/TabBar

@onready var research_tab: ScrollContainer = $List/PanelContainer/Research
@onready var statistics_tab: ScrollContainer = $List/PanelContainer/Statistics
@onready var main_container: PanelContainer = $List/PanelContainer

@onready var emissions_contributors: Label = $List/PanelContainer/Statistics/StatisticsContainer/EmissionsContainer/VBoxContainer/EmissionsContributors
@onready var wildfire_contributors: Label = $List/PanelContainer/Statistics/StatisticsContainer/WildfireContainer/VBoxContainer/WildfireContributors
@onready var tree_pollution_contributors: Label = $List/PanelContainer/Statistics/StatisticsContainer/TreePollutionContainer/VBoxContainer/TreePollutionContributors
@onready var smog_contributors: Label = $List/PanelContainer/Statistics/StatisticsContainer/SmogContanier/VBoxContainer/SmogContributors


var available_research: Array[ResearchData] = [
	load("res://resources/research_data/steel_mill_upgrade1.tres"),
	load("res://resources/research_data/CoalMineUpgrade1.tres"),
	load("res://resources/research_data/WoodCutterUpgrade1.tres"),
	load("res://resources/research_data/iron_mine_upgrade1.tres"),
]
var research_lab_selected: ResearchLab = null
var research_entry_scene: PackedScene = preload("res://scenes/UI/ResearchUI/Research_Entry.tscn")
var research_entries: Array[ResearchEntry]

func _ready() -> void:
	super()
	
	init_contributors()
	
	tab_bar.tab_clicked.connect(_set_tab_visible)
	for research in available_research:
		var research_entry: ResearchEntry = research_entry_scene.instantiate()
		research_entry.research_data = research
		research_entries.append(research_entry)
		research_container.add_child(research_entry)
	PollutionStatistics.emissions_not_absorbed.connect(update_contributor_percentage)
	hide()

func init_contributors() -> void:
	for emission in Enums.emissions:	
		emissions_contributors.text += "\n" + Enums.resource_type_to_string(emission) + ": ???"
		
	for emission in Enums.emissions_contributing_to_wildfires:
		wildfire_contributors.text += "\n" + Enums.resource_type_to_string(emission) + ": ???"
		
	for emission in Enums.emissions_contributing_to_tree_pollution:
		tree_pollution_contributors.text += "\n" + Enums.resource_type_to_string(emission)
	
	for emission in Enums.emissions_contributing_to_smog:
		smog_contributors.text += "\n" + Enums.resource_type_to_string(emission) + ": ???"

func update_contributor_percentage(emissions: Dictionary[Enums.ResourceType, float]) -> void:
	## TODO: get 100% distribution over the specific contributors
	var total_emissions_distribution: Dictionary[Enums.ResourceType, float] = get_distribituion_percentage(Enums.emissions, emissions) 
	var wildfire_emissions_distribution: Dictionary[Enums.ResourceType, float] = get_distribituion_percentage(Enums.emissions_contributing_to_wildfires.keys(), emissions) 
	var smog_emissions_distribution: Dictionary[Enums.ResourceType, float] = get_distribituion_percentage(Enums.emissions_contributing_to_smog.keys(), emissions) 

	emissions_contributors.text = "Contributors"
	wildfire_contributors.text = "Contributors"
	smog_contributors.text = "Contributors"
	
	if not total_emissions_distribution.is_empty():
		for emission in total_emissions_distribution.keys():
			var percentage: String = "%.2f" % total_emissions_distribution.get(emission) + "%."
			emissions_contributors.text += "\n" + Enums.resource_type_to_string(emission) + ": " + percentage
			
	if not wildfire_emissions_distribution.is_empty():
		for emission in Enums.emissions_contributing_to_wildfires:
			var percentage: String = "%.2f" % wildfire_emissions_distribution.get(emission) + "%."
			wildfire_contributors.text += "\n" + Enums.resource_type_to_string(emission) + ": " + percentage
			
	if not smog_emissions_distribution.is_empty():	
		for emission in Enums.emissions_contributing_to_smog:
			var percentage: String = "%.2f" % smog_emissions_distribution.get(emission) + "%."
			smog_contributors.text += "\n" + Enums.resource_type_to_string(emission) + ": " + percentage

func get_distribituion_percentage(emissions: Array[Enums.ResourceType], emissions_not_absorbed: Dictionary[Enums.ResourceType, float]) -> Dictionary[Enums.ResourceType, float]:
	var total: float = 0.0
		
	for emission in emissions_not_absorbed.keys():
		if emission in emissions:
			var amount: float = emissions_not_absorbed.get(emission)
			total += amount
	
	if total == 0.0:
		return {}
	
	var result: Dictionary[Enums.ResourceType, float] = {}
	
	for emission in emissions:
		result[emission] = (emissions_not_absorbed[emission] / total) * 100.0
	
	return result

func _set_tab_visible(tab_num: int) -> void:
	for child in main_container.get_children():
		child.hide()
	main_container.get_child(tab_num).show()
	
#Open UI
func open(research_lab_clicked: ResearchLab) -> void:
	reset_tabs()
	research_lab_selected = research_lab_clicked
	research_lab_selected.currently_selected = true
	ResearchSignals.research_lab_selected.emit(research_lab_selected)
	show()

func reset_tabs() -> void:
	research_tab.show()
	statistics_tab.hide()
	tab_bar.current_tab = 0

#Close UI
func close() -> void:
	research_lab_selected.currently_selected = false
	ResearchSignals.research_lab_selected.emit(null)
	hide()
