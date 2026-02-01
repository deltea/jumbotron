class_name Player
extends CharacterBody2D

@export var move_speed = 120.0
@export var walk_tilt = 10.0
@export var walk_tilt_speed = 1500.0
@export var bat_rot_offset = 125.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var bat: Node2D = $Bat
@onready var bat_sprite: Sprite2D = $Bat/Sprite2D
@onready var arrow: Node2D = $Arrow

@onready var bat_pos_dynamics: DynamicsSolverVector = Dynamics.create_dynamics_vector(8, 1, 2)
@onready var bat_rot_dynamics: DynamicsSolver = Dynamics.create_dynamics(4, 0.4, 2)

var target_bat_rot = bat_rot_offset

func _ready() -> void:
	print(bat_rot_dynamics.f, bat_rot_dynamics.z, bat_rot_dynamics.r)

func _process(dt: float) -> void:
	var mouse_angle = get_angle_to(get_global_mouse_position()) + PI/2
	arrow.rotation = mouse_angle
	bat.position = bat_pos_dynamics.update(global_position)
	bat.rotation = mouse_angle + bat_rot_dynamics.update(deg_to_rad(target_bat_rot))

func _physics_process(dt: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	velocity = input.normalized() * move_speed
	sprite.rotation_degrees = sin(Clock.time * walk_tilt_speed * dt) * walk_tilt if input else 0.0

	if Input.is_action_just_pressed("lmb"):
		swing_bat()

	move_and_slide()

func swing_bat():
	target_bat_rot = -target_bat_rot
