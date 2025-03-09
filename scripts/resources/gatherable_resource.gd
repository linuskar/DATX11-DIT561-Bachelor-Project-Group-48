class_name GatherableResource
extends Area2D
## A class that represents a resource that is gatherable
##
## A class that represents a resource that is gatherable in a game map
##

# var quantity: int

## The type of resource that is gathered
@export var resource_type: Enums.ResourceType

## Function for gathering resource
func gather_resource() -> int: 
	# TODO: Add possibility for resource depletion
	# quantity -= 1
	# if quantity <= 0 then resource is depleted
	var amount: int = 1
	return amount
