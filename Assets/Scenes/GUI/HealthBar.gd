extends Control

onready var over_health_bar = $HealthBar
onready var under_health_bar = $HealthBarDanger
onready var update_tween = $Tween
	
func _on_set_max_health(max_health):
	over_health_bar.max_value = max_health
	under_health_bar.max_value = max_health

func _on_update_health(health, amount):
	over_health_bar.value = health
	update_tween.interpolate_property(under_health_bar, "value", under_health_bar.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	update_tween.start()
