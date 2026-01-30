class_name Player
extends CharacterBody2D

@export var move_speed = 120.0
@export var walk_tilt = 8.0
@export var walk_tilt_speed = 1500.0

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(dt: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	velocity = input.normalized() * move_speed
	sprite.rotation_degrees = sin(Clock.time * walk_tilt_speed * dt) * walk_tilt if input else 0

	move_and_slide()
