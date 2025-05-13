class_name ResearchUI
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

## NOTE: For update of statistics it is very performant, for future implementation requires work on 
## optimization
var available_research: Array[ResearchData] = [
	## load("res://resources/research_data/total_emissions_statistics.tres"),
	## load("res://resources/research_data/wildfire_emissions_statistics.tres"),
	## load("res://resources/research_data/smog_emissions_statistics.tres.tres"),
	load("res://resources/research_data/steel_mill_unlock.tres"),
	load("res://resources/research_data/saw_mill_unlock.tres"),
	load("res://resources/research_data/gear_factory_unlock.tres"),
	load("res://resources/research_data/biomass_power_plant_unlock.tres"),
	load("res://resources/research_data/steel_mill_upgrade1.tres"),
	load("res://resources/research_data/CoalMineUpgrade1.tres"),
	load("res://resources/research_data/WoodCutterUpgrade1.tres"),
	load("res://resources/research_data/iron_mine_upgrade1.tres"),
]
var research_lab_selected: ResearchLab = null
var research_entry_scene: PackedScene = preload("res://scenes/UI/ResearchUI/Research_Entry.tscn")
var research_entries: Array[ResearchEntry]

var completed_research: Array[Enums.ResearchID]

func _ready() -> void:
	super()
	
	init_contributors()
	
	tab_bar.tab_clicked.connect(_set_tab_visible)
	for research in available_research:
		var research_entry: ResearchEntry = research_entry_scene.instantiate()
		research_entry.research_data = research
		research_entries.append(research_entry)
		research_container.add_child(research_entry)
		
	## NOTE: This is very bad for performance
	##PollutionStatistics.emissions_not_absorbed.connect(update_contributor_percentage)
	## ResearchSignals.research_completed.connect(add_completed_research)
	hide()

func add_completed_research(research_data: ResearchData) -> void:
	completed_research.append(research_data.research_id)

func init_contributors() -> void:
	for emission in Enums.emissions:	
		emissions_contributors.text += "\n" + Enums.resource_type_to_string(emission)
		
	for emission in Enums.emissions_contributing_to_wildfires:
		wildfire_contributors.text += "\n" + Enums.resource_type_to_string(emission)
		
	for emission in Enums.emissions_contributing_to_tree_pollution:
		tree_pollution_contributors.text += "\n" + Enums.resource_type_to_string(emission)
	
	for emission in Enums.emissions_contributing_to_smog:
		smog_contributors.text += "\n" + Enums.resource_type_to_string(emission)

## NOTE: This is very bad for performance
func update_contributor_percentage(emissions: Dictionary[Enums.ResourceType, float]) -> void:
	if Enums.ResearchID.TE in completed_research:
		update_emissions_percentage(emissions_contributors, Enums.emissions, emissions) 
	if Enums.ResearchID.WE in completed_research:
		update_emissions_percentage(wildfire_contributors, Enums.emissions_contributing_to_wildfires.keys(), emissions) 
	if Enums.ResearchID.SE in completed_research:
		update_emissions_percentage(smog_contributors, Enums.emissions_contributing_to_smog.keys(), emissions) 

func update_emissions_percentage(label: Label, specific_emissions: Array[Enums.ResourceType], total_emissions: Dictionary[Enums.ResourceType, float]) -> void:
	var emissions_distribution: Dictionary[Enums.ResourceType, float] = get_distribituion_percentage(specific_emissions, total_emissions) 
	if not emissions_distribution.is_empty():
		label.text = "Contributors"
		for emission in emissions_distribution.keys():
			var percentage: String = "%.2f" % emissions_distribution.get(emission) + "%."
			label.text += "\n" + Enums.resource_type_to_string(emission) + ": " + percentage

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
	research_lab_selected.building_deselected(research_lab_selected)
	ResearchSignals.research_lab_selected.emit(null)
	hide()

func hide_ui_menu() -> void:
	close()
