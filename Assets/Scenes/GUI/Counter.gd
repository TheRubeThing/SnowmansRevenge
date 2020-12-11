extends Control


export(int) var count = 0
var _total_number = 0

func _ready():
	$HBoxContainer/RichTextLabel.text = "0"
	
func set_total_number(total : int):
	_total_number = total
	_update_text()
	
func update_count(amount : int):
	count += amount
	_update_text()
	
func _update_text():
	$HBoxContainer/RichTextLabel.text = str(count) + "/" + str(_total_number)
