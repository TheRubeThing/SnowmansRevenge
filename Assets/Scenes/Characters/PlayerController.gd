extends KinematicBody2D


export(float) var move_speed : float = 130
export(float) var roll_speed : float = 300
export(float) var jump_height : float = 90	
export(float) var jump_distance : float = 40
export(float) var ground_ease : float = 0.8
export(float) var roll_ease : float = 0.95
export(float) var air_ease : float = 0.6
export(float) var ground_stop_threshold : float = 2
export(float) var drop_jump_time : float = 0.1
export(float) var max_health : float = 100.0
export(float) var snow_ball_cost : float = 2
export(float) var melt_amount : float = 0.25
export(PackedScene) var respawn_scene

onready var _velocity := Vector2.ZERO
onready var _gravity : float = 0
onready var _jump_speed : float = 0
onready var _just_grounded : bool = false
onready var _drop_jump_timer : float = 0
onready var _health = max_health

var _dead : bool = false
onready var _start_position = position

signal update_health(health, amount)
signal set_max_health(max_health)
signal set_trauma(trauma)

func _ready():
	emit_signal("set_max_health", max_health)
	emit_signal("update_health", _health, 0)
	
func _input(event):
	if event.is_action_pressed("Fire"):
		if not Input.is_action_pressed("RollMod"):
			$AnimatedSprite/FirePosition.fire()

func _process(delta):
	if not _dead:
		_calculate_jump_parameters()
		
		_drop_jump_timer += delta
		
		_health -= delta * melt_amount
		emit_signal("update_health", _health, 0)
		check_dead()
		
		# Animations
		if _is_grounded():
			if abs(_velocity.x) > ground_stop_threshold:
				if Input.is_action_pressed("RollMod"):
					if not $RollSound.playing:
						$RollSound.play()
					$AnimatedSprite.play("Roll")
				else:
					if not $WalkingSound.playing:
						$WalkingSound.play()
					$AnimatedSprite.play("Walk")
			else:
				$RollSound.stop()
				if not Input.is_action_pressed("RollMod"):
					$WalkingSound.stop()
					$AnimatedSprite.stop()
					$AnimatedSprite.play("Idle")
		else:
			# Freeze animation to set frames manually
			$RollSound.stop()
			$WalkingSound.stop()
			$AnimatedSprite.play("Jump")
			$AnimatedSprite.stop()
			if abs(_velocity.y) > 0.8 * _jump_speed:
				$AnimatedSprite.frame = 2
			elif abs(_velocity.y) > 0.4 * _jump_speed:
				$AnimatedSprite.frame = 1
			else:
				$AnimatedSprite.frame = 0

func _physics_process(delta):
	if not _dead:
		# Collider shape mod
		if Input.is_action_pressed("RollMod"):
			detect_snow()
			$MovementCollisionShape.shape.extents.y = $MovementCollisionShape.shape.extents.x - 1
			$MovementCollisionShape.position.y = $MovementCollisionShape.shape.extents.x
		else:
			$MovementCollisionShape.shape.extents.y = 2 * $MovementCollisionShape.shape.extents.x - 2
			$MovementCollisionShape.position.y = 2
			
		$PlayerHitbox/HitboxShape.shape.extents = $MovementCollisionShape.shape.extents
		$PlayerHitbox/HitboxShape.position.y = $MovementCollisionShape.position.y
		# Get player movement input
		if Input.is_action_pressed("Left"):
			if Input.is_action_pressed("RollMod") && _is_grounded():
				_velocity.x += (1 - roll_ease) * (-1 * roll_speed - _velocity.x)
			else:
				_velocity.x += (1 - ground_ease) * (-1 * move_speed - _velocity.x)
			set_sprite_direction(-1)
		elif Input.is_action_pressed("Right"):
			if Input.is_action_pressed("RollMod") && _is_grounded():
				_velocity.x += (1 - roll_ease) * (1 * roll_speed - _velocity.x)
			else:
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
			# Ground shake when landning
			if not _just_grounded && abs(_velocity.y) > 1.1 * _jump_speed:
				emit_signal("set_trauma", min(_velocity.y / (6 * _jump_speed), 1.0))
				
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
	
func detect_snow():
	for body in $SnowDetector.get_overlapping_bodies():
		var cell = body.world_to_map(position)
		cell.y += 1
		body.set_cell(cell.x, cell.y, -1)
		_health += 0.25
		_health = clamp(_health, 0, max_health)
		emit_signal("update_health", _health, 0)
		print("Snow!")
	
func set_sprite_direction(direction : int) -> void:
	$AnimatedSprite.scale.x = -1 * direction
	
func _calculate_jump_parameters() -> void:
	_gravity = jump_height / pow((jump_distance / move_speed), 2)
	_jump_speed = sqrt(2 * jump_height * _gravity)
	
func _is_grounded() -> bool:
	return test_move(transform, Vector2(0,0.1))
	
func _is_walled() -> bool:
	var direction : float = 0
	if _velocity.x != 0:
		direction = _velocity.x / abs(_velocity.x)
	return test_move(transform, Vector2(direction,0))
	
func damage(damage):
	if not _dead:
		if $InvisiblityTimer.is_stopped():
			$InvisiblityTimer.start()
			$AnimationPlayer.play("Flash")
			$AnimationPlayer.queue("Flimmer")
			_health -= damage
			emit_signal("update_health", _health, 0)
			emit_signal("set_trauma", 0.5)
			check_dead()


func _on_PlayerHitbox_body_entered(body):
	damage(body.get_damage())


func _on_FirePosition_fired():
	if not _dead:
		_health -= snow_ball_cost
		emit_signal("update_health", _health, 0)
		check_dead()


func _on_InvisiblityTimer_timeout():
	$AnimationPlayer.play("Idle")
	for body in $PlayerHitbox.get_overlapping_bodies():
		damage(body.get_damage())
		
func check_dead():
	if _health <= 0:
		_dead = true
		visible = false
		$DeathParticles/Position2D.spawn_snow()
		$DeathParticles/Position2D2.spawn_snow()
		$DeathParticles/Position2D3.spawn_snow()
		$DeathTime.start()


func _on_DeathTime_timeout():
	_health = max_health
	position = _start_position
	visible = true
	_dead = false
	$DeathTime.stop()
