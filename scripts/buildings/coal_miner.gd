extends Building

##The max amount of resources the building can keep
@export var  maxStorageCoal: int = 20

##How much coal is generated each cycle, cyclespeed is timer wait time
@export var coalGenerated: int = 5

##How much co2 emits per cycle, not saved in the building
@export var co2Emission: int = 5

## The resource the building can gather
@export var can_gather_resource_type: Enums.ResourceType

var currentStorageCoal: int = 0

func _ready():
	#Connect the signal that can take resources from this building
	ResourceSignals.get_resource.connect(_send_resources)

#Activated at the end of each cycle
func _on_timer_timeout() -> void:
	add_resources()

#Add the resources to the storage and emit what have been created
func add_resources():
	ResourceSignals.add_resource.emit("co2", co2Emission)
	if currentStorageCoal + coalGenerated <= maxStorageCoal:
		currentStorageCoal += coalGenerated
		ResourceSignals.add_resource.emit("Coal", coalGenerated)
	else:
		$Timer.stop()

#Take resources from this buildings storage
func _send_resources(resource_type, amount):
	if resource_type == "Coal":
		currentStorageCoal -= amount
		$Timer.autostart()
