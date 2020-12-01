extends KinematicBody2D


export(float) var move_speed : float = 150
export(float) var jump_height : float = 90	
export(float) var jump_distance : float = 50
export(float) var ground_ease : float = 0.8
export(float) var air_ease : float = 0.7
export(float) var ground_stop_threshold : float = 2
export(float) var drop_jump_time : float = 0.1

onready var _velocity := Vector2.ZERO
onready var _gravity : float = 0
onready var _jump_speed : float = 0
onready var _just_grounded : bool = false
onready var _drop_jump_timer : float = 0

func _process(delta):
	_calculate_jump_parameters()
	
	_drop_jump_timer += delta
	
	# Animations
	if _is_grounded():
		if abs(_velocity.x) > 0:
			$AnimatedSprite.play("Walk")
		else:
			$AnimatedSprite.play("Idle")
	else:
		# Freeze animation to set frames manually
		$AnimatedSprite.play("Jump")
		$AnimatedSprite.stop()
		if abs(_velocity.y) > 0.8 * _jump_speed:
			$AnimatedSprite.frame = 2
		elif abs(_velocity.y) > 0.4 * _jump_speed:
			$AnimatedSprite.frame = 1
		else:
			$AnimatedSprite.frame = 0

func _physics_process(delta):
	# Get player movement input
	if Input.is_action_pressed("Left"):
		_velocity.x += (1 - ground_ease) * (-1 * move_speed - _velocity.x)
		set_sprite_direction(-1)
	elif Input.is_action_pressed("Right"):
		_velocity.x += (1 - ground_ease) * (1 * move_speed - _velocity.x)
		set_sprite_direction(1)
	else:
		_velocity.x *= ground_ease
		if abs(_velocity.x) < ground_stop_threshold:
			_velocity.x = 0
			
	# Check if colliding with wall
	if _is_walled():
		_velocity.x = 0
		
	# Apply gravity if not grounded
	if _is_grounded():
		_just_grounded = true
		if	Input.is_action_just_pressed("Jump"):
			_velocity.y -= _jump_speed
		else:
			_velocity.y = 0
	else:
		#enable jumping if just fell off ledge
		if _just_grounded:
			_just_grounded = false
			_drop_jump_timer = 0
		if	Input.is_action_just_pressed("Jump") && _drop_jump_timer < drop_jump_time:
			_velocity.y -= _jump_speed
			
		if (Input.is_action_pressed("Jump") == false && _velocity.y < 0):
			_velocity.y *= air_ease
		if  is_on_ceiling():
			_velocity.y = 0
			
		_velocity.y += _gravity * delta
	
	# Execute movement
	move_and_slide(_velocity, Vector2.UP)
	
func set_sprite_direction(direction : int) -> void:
	$AnimatedSprite.flip_h = (direction > 0)
	
func _calculate_jump_parameters() -> void:
	_gravity = jump_height / pow((jump_distance / move_speed), 2)
	_jump_speed = sqrt(2 * jump_height * _gravity)
	
func _is_grounded() -> bool:
	return test_move(transform, Vector2(0,1))
	
func _is_walled() -> bool:
	var direction : float = 0
	if _velocity.x != 0:
		direction = _velocity.x / abs(_velocity.x)
	return test_move(transform, Vector2(direction,0))
