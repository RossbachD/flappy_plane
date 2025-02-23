extends Node2D

func _process(delta: float) -> void:
	if position.x <= -1600:
		position.x = 0
