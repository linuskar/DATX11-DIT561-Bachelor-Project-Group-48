class_name MapLayer
extends Node2D
## A class that representing the layers of the game map
##
## A class that representing the differemt TileMapLayers of the game map
##

## The water layer of the TileMap
@onready var water_layer: TileMapLayer = $Water
## The diort layer of the TileMap
@onready var dirt_layer: TileMapLayer = $Dirt
## The stone layer of the TileMap
@onready var stone_layer: TileMapLayer = $Stone
## The grass layer of the TileMap
@onready var grass_layer: TileMapLayer = $Grass
## The resources layer of the TileMap
@onready var resources_layer: TileMapLayer = $Resources
