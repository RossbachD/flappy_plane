extends Node

var dynamic_objects_speed: int = 700

func _process(_delta: float) -> void:
	for dynamic_object in get_tree().get_nodes_in_group("Dynamic_Object"):
		dynamic_object.position.x -= _delta * dynamic_objects_speed
