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

## Reference to the image
@onready var texture_rect: TextureRect = $PanelContainer/MarginContainer/HBoxContainer/ResourceInfo/ResourcePicture

## Reference to the label
@onready var sell_amount_text: Label = $PanelContainer/MarginContainer/HBoxContainer/MarginContainer/SellingStorage/Label

func _process(delta: float) -> void:
	if resource_held > int(sell_amount_text.text):
		sell_amount_text.text = str(resource_held)

func _ready() -> void:
	var path: String = Enums.resource_image_paths.get(resource)
	var image = load(path)
	self.texture_rect.set_texture(image)

static func create_instance(new_resource: Enums.ResourceType, stored_amount: int) -> StoredResourcePanel:
	var new_stored_resource: StoredResourcePanel = scene.instantiate()
	new_stored_resource.resource = new_resource
	new_stored_resource.resource_held = stored_amount
	return new_stored_resource

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
