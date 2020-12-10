extends Control


export(int) var count = 0

func _ready():
	$HBoxContainer/RichTextLabel.text = "0"
	
func update_count(amount : int):
	count += amount
	$HBoxContainer/RichTextLabel.text = str(count)
