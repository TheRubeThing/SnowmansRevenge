extends KinematicBody2D
class_name Snowball

export(float) var gravity = 98
export(float) var speed = 400
export(PackedScene) var snow_particles

onready var _velocity : Vector2 = Vector2.ZERO
onready var _snow_tiles : TileMap = get_node("../Snow")
onready var _ground_tiles : TileMap = get_node("../ground")

var _stopped = false

func _physics_process(delta):
	_velocity.y += gravity * delta 
	move_and_slide(_velocity, Vector2.UP)
	if (is_on_wall() || is_on_ceiling()) && not _stopped:
		_velocity = Vector2.ZERO
		_stopped = true
		$SnowTHud.play()
	if _is_grounded():
		var cell = _snow_tiles.world_to_map(position)
		if _ground_tiles.get_cell(cell.x, cell.y + 1) != -1:
			_snow_tiles.set_cell(cell.x, cell.y + 1, 0)
		else:
			if (int(position.x) % 16) > 8:
				_snow_tiles.set_cell(cell.x + 1, cell.y + 1, 0)
			else:
				_snow_tiles.set_cell(cell.x - 1, cell.y + 1, 0)
				
		spawn_snow()
		queue_free()
	
func _is_grounded() -> bool:
	return test_move(transform, Vector2(0,0.1))
	
func set_direction(direction : Vector2) -> void:
	_velocity = direction.normalized() * speed
	
func spawn_snow():
	var particles = snow_particles.instance()
	particles.position = position
	get_parent().add_child(particles)
