class_name GatherableResource
extends Area2D
## A class that represents a resource that is gatherable
##
## A class that represents a resource that is gatherable in a game map
##

## The quantity of the resource
@export var quantity: int

## The type of resource that is gathered
@export var resource_type: Enums.ResourceType

## Function for gathering resource
func gather_resource(amount_to_gather: int) -> int: 
	## Get the amount of resources, 
	## the min is for the case when the resource quantity <= 0
	var gathered_amount: int = min(amount_to_gather, quantity)
	quantity -= amount_to_gather
	
	if quantity <= 0:
		queue_free()
		
	return gathered_amount
