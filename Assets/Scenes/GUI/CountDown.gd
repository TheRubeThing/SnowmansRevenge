extends Control


export(float) var time = 180

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = time
	$Timer.start()

func reset_timer():
	$Timer.stop()
	$Timer.wait_time = time
	$Timer.start()
	
func completion_time() -> float:
	return time - $Timer.time_left

func _on_Timer_timeout():
	SceneManager.goto_game_over()
