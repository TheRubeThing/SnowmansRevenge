extends KinematicBody2D
class_name Snowball

export(float) var gravity = 98
export(float) var speed = 200

onready var _velocity : Vector2 = Vector2.ZERO

func _physics_process(delta):
	_velocity.y += gravity * delta 
	move_and_slide(_velocity, Vector2.UP)
	if _is_grounded():
		queue_free()
	
func _is_grounded() -> bool:
	return test_move(transform, Vector2(0,0.1))
	
func set_direction(direction : Vector2) -> void:
	_velocity = direction.normalized() * speed
