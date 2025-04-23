class_name WildFire
extends Node2D
@onready var smoke_fire: GPUParticles2D = $Smoke_fire
@onready var fire: GPUParticles2D = $Fire

func start_fire() -> void:
	smoke_fire.emitting = true
	fire.emitting = true

func stop_fire() -> void:
	smoke_fire.emitting = false
	fire.emitting = false
