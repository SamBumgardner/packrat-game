extends GPUParticles2D

@export var particle_destination : Vector2 = Vector2.ZERO

func _ready():
	process_material.set_shader_parameter("destination", particle_destination)
