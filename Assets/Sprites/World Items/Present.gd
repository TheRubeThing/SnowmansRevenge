extends Area2D

export(float) var floating_freq = 1.0
export(float) var floating_amp = 1.0

var _phase = 0

onready var start_position := position

func _physics_process(delta):
	_phase += delta
	position.y = start_position.y + floating_amp * sin(2 * PI * _phase * floating_freq)


func _on_Present_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
