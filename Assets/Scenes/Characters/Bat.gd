extends KinematicBody2D

export(float) var move_speed : float = 30
export(float) var damage : float = 10
export(float) var max_health : float = 20

var _start_position : Vector2 = Vector2.ZERO
var _direction : Vector2 = Vector2.ZERO

onready var _health = max_health

signal dead()

func _ready():
	_start_position = position
	$AnimatedSprite.stop()
	randomize()
	yield(get_tree().create_timer(rand_range(0,1.0)), "timeout")
	$FlapSound.play()
	$AnimatedSprite.play()

func _physics_process(delta):
	var direction = _get_direction()
	if direction.length() > 10:
		direction = direction.normalized()
	else:
		direction = Vector2.ZERO
		
	move_and_slide(direction * move_speed, Vector2.UP)
	
func _get_direction() -> Vector2:
	for body in $PlayerDetectArea.get_overlapping_bodies():
		if body.is_in_group("Player"):
			return (body.position - position)
	return (_start_position - position)
	
func get_damage() -> float:
	return damage


func _on_HitBox_body_entered(body):
	if body.is_in_group("PlayerProjectile"):
		if $InvisiblityTimer.is_stopped():
			$DamageSound.play()
			body.spawn_snow()
			$InvisiblityTimer.start()
			$AnimationPlayer.play("Flash")
			$AnimationPlayer.queue("Flutter")
			_health -= 10
			if _health <= 0:
				emit_signal("dead")
				queue_free()


func _on_InvisiblityTimer_timeout():
	$AnimationPlayer.play("Idle")
