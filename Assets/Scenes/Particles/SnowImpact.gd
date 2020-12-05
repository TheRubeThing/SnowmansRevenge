extends Particles2D

onready var timeout = lifetime

func _ready():
	print("Snow impact")
	emitting = true

func _process(delta):
	timeout -= delta
	if timeout <= 0:
		queue_free()
