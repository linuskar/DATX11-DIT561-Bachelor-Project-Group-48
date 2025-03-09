class_name MapLayer
extends Node2D
## A class that representing the layers of the game map
##
## A class that representing the differemt TileMapLayers of the game map
##

@onready var water_layer: TileMapLayer = $Water
@onready var dirt_layer: TileMapLayer = $Dirt
@onready var stone_layer: TileMapLayer = $Stone
@onready var grass_layer: TileMapLayer = $Grass
@onready var resources_layer: TileMapLayer = $Resources
