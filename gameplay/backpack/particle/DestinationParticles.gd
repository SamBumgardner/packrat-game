class_name DestinationParticles extends GPUParticles2D

@export var particle_destination : Vector2 = Vector2.ZERO :
	set(value):
		particle_destination = value
		process_material.set_shader_parameter("destination", Vector3(particle_destination.x, particle_destination.y, 0.0))

func _ready():
	process_material.set_shader_parameter("destination", particle_destination) 
