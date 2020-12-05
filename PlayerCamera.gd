extends Camera2D

export(float) var smoothing = 0.05
export(Vector2) var target_offset = Vector2.ZERO

var _old_player_pos = Vector2.ZERO

func _physics_process(delta):
	var player_velocity = (get_node("../Player").position - _old_player_pos) / delta
	var direction = get_node("../Player").position - position
	direction += target_offset * (1.0 - abs(player_velocity.y) / 200.0)
	var factor = direction.length() * smoothing
	position += direction * factor * delta
	_old_player_pos = get_node("../Player").position
