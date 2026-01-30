class_name Player
extends CharacterBody2D

@export var move_speed: float = 200.0

func _physics_process(delta):
	var input = Input.get_vector("left", "right", "up", "down")
	velocity = input.normalized() * move_speed
	move_and_slide()
