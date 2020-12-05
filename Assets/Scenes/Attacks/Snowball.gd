extends KinematicBody2D
class_name Snowball

export(float) var gravity = 98
export(float) var speed = 400
export(PackedScene) var snow_particles

onready var _velocity : Vector2 = Vector2.ZERO
onready var _snow_tiles : TileMap = get_node("../Snow")

func _physics_process(delta):
	_velocity.y += gravity * delta 
	move_and_slide(_velocity, Vector2.UP)
	if is_on_wall() || is_on_ceiling():
		_velocity = Vector2.ZERO
	if _is_grounded():
		var cell = _snow_tiles.world_to_map(position)
		_snow_tiles.set_cell(cell.x, cell.y + 1, 0)
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
