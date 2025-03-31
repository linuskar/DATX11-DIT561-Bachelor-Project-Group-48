extends Node

#pathfinding for the truck/transport veichle
var astargrid2d = AStarGrid2D.new()

var road_positions: Array[Vector2] = []

#
signal update_truck_path()

#Send the resource type and the amount to add
signal add_resource(resource_type: Enums.ResourceType, amount: int)

#Send the resource type and the amount to add
signal get_resource(resource_type: Enums.ResourceType, amount: int)

#Send the resource type and the amount to remove
signal use_resource(resource_type: Enums.ResourceType, amount: int)

#Send the resource type and the new amount to show
signal update_UI(resource_type: Enums.ResourceType, amount: int)
