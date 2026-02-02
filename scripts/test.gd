extends Node3D

func _process(dt: float) -> void:
	rotation_degrees.y += 20.0 * dt
	rotation_degrees.x = sin(Clock.time) * 20.0
