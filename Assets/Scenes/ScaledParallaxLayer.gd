extends ParallaxLayer
class_name ScaledParallaxLayer

func _ready():
	if $Art:
		$Art.scale = motion_scale
