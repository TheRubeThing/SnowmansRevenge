extends Camera2D

export(float) var smoothing = 0.05
export(PackedScene) var target
export(Vector2) var target_offset = Vector2.ZERO
export(Vector2) var max_shake_offset = Vector2(100,75)
export(float) var shake_decay := 0.8

onready var _noise = OpenSimplexNoise.new()

var _noise_y = 0
var _trauma = 0.0
var _trauma_power = 2
var _old_player_pos = Vector2.ZERO

func _ready():
	randomize()
	_noise.seed = randi()
	_noise.period = 6
	_noise.octaves = 2
	
func _physics_process(delta):
	if _trauma:
		_trauma = max(_trauma - shake_decay * delta, 0)
	var player_velocity = (get_node("../Player").position - _old_player_pos) / delta
	var direction = get_node("../Player").position - position
	direction += target_offset * (1.0 - abs(player_velocity.y) / 200.0)
	var factor = direction.length() * smoothing
	position += direction * factor * delta
	_old_player_pos = get_node("../Player").position
	shake()
	
func add_trauma(amount):
	_trauma = min(_trauma + amount, 1.0)
	
func shake():
	var amount = pow(_trauma, _trauma_power)
	_noise_y += 1
	offset.x = max_shake_offset.x * amount * _noise.get_noise_2d(_noise.seed*2, _noise_y)
	offset.y = max_shake_offset.y * amount * _noise.get_noise_2d(_noise.seed*3, _noise_y)


func _on_Player_set_trauma(trauma):
	add_trauma(trauma)
