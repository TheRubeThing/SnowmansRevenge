extends Node2D

var _initial_bat_count = 0
var _initial_present_count = 0

func _ready():
	var tree = get_tree()
	var bats = tree.get_nodes_in_group("Bat")
	_initial_bat_count = bats.size()
	$Camera2D/BatCounter.set_total_number(_initial_bat_count)
	for bat in bats:
		bat.connect("dead", self, "_on_Bat_dead")
		
	var presents = tree.get_nodes_in_group("Present")
	_initial_present_count = presents.size()
	$Camera2D/PresentCounter.set_total_number(_initial_present_count)
	for present in presents:
		present.connect("collected", self, "_on_Present_pickup")

func increase_bat_count(amount : int):
	$Camera2D/BatCounter.update_count(amount)
	_initial_bat_count -= amount
	check_win()
	
func increase_present_count(amount : int):
	$Camera2D/PresentCounter.update_count(amount)
	_initial_present_count -= amount
	check_win()
	
func check_win():
	if _initial_bat_count == 0 && _initial_present_count == 0:
		GameData.completion_time = $Camera2D/CountDown.completion_time()
		SceneManager.goto_next_level_screen()
	
func reset_timer():
	$Camera2D/CountDown.reset_timer()
	
func _on_Bat_dead():
	increase_bat_count(1)
	
func _on_Present_pickup():
	increase_present_count(1)
	


func _on_Gate_Trigger():
	pass # Replace with function body.
