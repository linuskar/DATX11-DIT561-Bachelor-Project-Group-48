class_name StoredResourcePanel extends Control

## Reference to this scene, used for correctness
## in create instance function
static var scene: PackedScene  = load("res://scenes/UI/stored_resource.tscn")

## The type of the resource
var resource: Enums.ResourceType

## The amount of the resource that is currently stored
var resource_held: int = 0

## How much of the stored resources the player has 
## chosen to sell
var resource_to_sell: int = 0

## Path to the image associated with this resource
var image_path: String

## Reference to the image
@onready var texture_rect: TextureRect = $PanelContainer/MarginContainer/HBoxContainer/ResourceInfo/ResourcePicture

## Reference to the label
@onready var sell_amount_text: Label = $PanelContainer/MarginContainer/HBoxContainer/MarginContainer/SellingStorage/Label

func _process(delta: float) -> void:
	update_text()

func ready_instance(new_resource: Enums.ResourceType, stored_amount: int) -> void:
	self.resource = new_resource
	self.resource_held = stored_amount
	self.texture_rect.set_texture(load(Enums.resource_image_paths.get(new_resource)))

## Triggered when pressing the Increase button, increases 
## selling resources by 1
func increase() -> void:
	if resource_to_sell + 1 >= resource_held:
		resource_to_sell = resource_held
	else: 
		resource_to_sell += 1

## Triggered when pressing the IncreaseMore button, increases
## selling resources by 5
func increase_more() -> void:
	if resource_to_sell + 5 >= resource_held:
		resource_to_sell = resource_held
	else: 
		resource_to_sell += 5

## Triggered when pressing the Decrease button, decreases 
## selling resources by 1
func decrease() -> void:
	if resource_to_sell - 1 <= 0:
		resource_to_sell = 0
	else:
		resource_to_sell -= 1

## Triggered when pressing the DecreaseMore button, decreases
## selling resources by 5
func decrease_more() -> void:
	if resource_to_sell - 5 <= 0:
		resource_to_sell = 0
	else:
		resource_to_sell -= 5

## Updates the text of the label to match the resources to sell count
func update_text() -> void:
	sell_amount_text.text = str(resource_to_sell)
