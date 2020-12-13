extends Particles2D


onready var _death_timer = lifetime

func _process(delta):
	_death_timer -= delta
	if _death_timer <= 0:
		queue_free()
