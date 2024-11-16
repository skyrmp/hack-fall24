extends Node2D


func set_ratio(ratio: float) -> void:
	var amt: int = $Sprite.hframes
	set_level(round(remap(ratio, 0.0, 1.0, amt - 1, 0))


func set_level(level: int) -> void:
	$Sprite.frame = level
