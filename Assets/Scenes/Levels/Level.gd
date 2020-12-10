extends Node2D

func increase_bat_count(amount : int):
	$Camera2D/BatCounter.update_count(amount)
