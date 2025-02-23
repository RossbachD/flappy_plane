extends RigidBody2D


var impulse_force : int = 1200

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		apply_central_impulse(Vector2.UP * impulse_force)
		pass
