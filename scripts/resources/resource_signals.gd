extends Node

#Send the resource type and the amount to add
signal add_resource(resource_type: Enums.ResourceType, amount: int, building: Building)

#Send the resource type and the amount to add
signal get_resource(resource_type: Enums.ResourceType, amount: int)

#Send the resource type and the amount to remove
signal use_resource(resource_type: Enums.ResourceType, amount: int)

#Send the resource type and the new amount to show
signal update_UI(resource_type: Enums.ResourceType, amount: int)

#Add a new building to inputs
signal add_input_building(building: StorageBuilding)
