extends Building

##The max amount of resources the building can keep
@export var maxStorageWood: int = 20

##How much wood is generated each cycle, cyclespeed is timer wait time
@export var woodGenerated: int = 5

##How much co2 emits per cycle, not saved in the building
@export var co2Emission: int = 5

## The resource the building can gather
@export var can_gather_resource_type: Enums.ResourceType

var currentStorageWood: int = 0

func _ready():
	#Connect the signal that can take resources from this building
	ResourceSignals.get_resource.connect(_send_resources)

#Activated at the end of each cycle
func _on_timer_timeout() -> void:
	add_resources()

#Add the resources to the storage and emit what have been created
func add_resources():
	ResourceSignals.add_resource.emit("co2", co2Emission)
	if currentStorageWood + woodGenerated <= maxStorageWood:
		currentStorageWood += woodGenerated
		ResourceSignals.add_resource.emit("Wood trunk", woodGenerated)
	else:
		$Timer.stop()

#Take resources from this buildings storage
func _send_resources(resource_type, amount):
	if resource_type == "Wood trunk":
		currentStorageWood -= amount
		$Timer.autostart()
