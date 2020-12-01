extends KinematicBody2D


export(float) var move_speed : float = 100
export(float) var jump_height : float = 50	
export(float) var jump_distance : float = 30

onready var _velocity := Vector2.ZERO
onready var _gravity : float = 0
onready var _jump_speed : float = 0

func _process(delta):
	_calculate_jump_parameters()

func _physics_process(delta):
	# Get player movement input
	if Input.is_action_pressed("Left"):
		_velocity.x = -1 * move_speed
		set_sprite_direction(-1)
	elif Input.is_action_pressed("Right"):
		_velocity.x = 1 * move_speed
		set_sprite_direction(1)
	else:
		_velocity.x = 0	
		
	# Apply gravity if not grounded
	if _is_grounded():
		if	Input.is_action_just_pressed("Jump"):
			_velocity.y -= _jump_speed
		else:
			_velocity.y = 0
	else:
		_velocity.y += _gravity * delta
		if Input.is_action_just_released("Jump") && _velocity.y < 0:
			_velocity.y = 0
	
	# Execute movement
	move_and_slide(_velocity, Vector2.UP)
	
func set_sprite_direction(direction : int) -> void:
	$Sprite.flip_h = (direction > 0)
	$Sprite.offset.x = direction * 6
	
func _calculate_jump_parameters() -> void:
	_gravity = jump_height / pow((jump_distance / move_speed), 2)
	_jump_speed = sqrt(2 * jump_height * _gravity)
	
func _is_grounded() -> bool:
	return test_move(transform, Vector2(0,1))
