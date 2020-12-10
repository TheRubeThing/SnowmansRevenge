extends Node2D

func increase_bat_count(amount : int):
	$Camera2D/BatCounter.update_count(amount)
	
func increase_present_count(amount : int):
	$Camera2D/PresentCounter.update_count(amount)
