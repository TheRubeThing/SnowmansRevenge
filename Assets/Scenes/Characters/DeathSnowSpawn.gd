extends Position2D


export(PackedScene) var snow_particles

func spawn_snow():
	var particles = snow_particles.instance()
	particles.position = to_global(position)
	get_parent().get_parent().get_parent().add_child(particles)
