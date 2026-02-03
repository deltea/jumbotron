class_name Player
extends CharacterBody2D

@export var move_speed = 120.0
@export var impulse_damping = 500.0
@export var walk_tilt = 10.0
@export var walk_tilt_speed = 1500.0
@export var bat_rot_offset = 125.0

@export var ball_hit_force = 200.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var bat: Node2D = $Bat
@onready var bat_sprite: Sprite2D = $Bat/Sprite2D
@onready var arrow: Node2D = $Arrow
@onready var hit_area: Area2D = $Arrow/HitArea

@onready var bat_pos_dynamics: DynamicsSolverVector = Dynamics.create_dynamics_vector(8, 1, 2)
@onready var bat_rot_dynamics: DynamicsSolver = Dynamics.create_dynamics(4, 0.4, 2)

var target_bat_rot = bat_rot_offset
var impulse_vel = Vector2.ZERO

func _ready() -> void:
	print(bat_rot_dynamics.f, bat_rot_dynamics.z, bat_rot_dynamics.r)

func _process(dt: float) -> void:
	var mouse_angle = get_angle_to(get_global_mouse_position()) + PI/2
	arrow.rotation = mouse_angle
	bat.position = bat_pos_dynamics.update(global_position)
	bat.rotation = mouse_angle + bat_rot_dynamics.update(deg_to_rad(target_bat_rot))

func _physics_process(dt: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	impulse_vel = impulse_vel.move_toward(Vector2.ZERO, impulse_damping * dt)
	velocity = input.normalized() * move_speed + impulse_vel
	sprite.rotation_degrees = sin(Clock.time * walk_tilt_speed * dt) * walk_tilt if input else 0.0

	if Input.is_action_just_pressed("lmb"):
		swing_bat()

	move_and_slide()

func swing_bat():
	target_bat_rot = -target_bat_rot

	var balls = hit_area.get_overlapping_bodies().filter(func(area): return area is Ball)
	for ball in balls:
		deflect(ball)

func knockback(direction: Vector2, force: float):
	impulse_vel = direction.normalized() * force

func deflect(ball: Ball):
	var distance = ball.position.distance_to(bat_sprite.global_position)
	# var auto_aim_enemy = auto_aim_ray.get_collider()
	await Clock.wait(distance / 1000)

	Clock.hitstop(0.07)
	knockback(position - get_global_mouse_position(), 200.0)
	# towards mouse pointer
	ball.linear_velocity = -(ball.position - get_global_mouse_position()).normalized() * ball_hit_force
	# Globals.camera.jerk_direction(position - get_global_mouse_position(), 5.0)
	# bat_sprite.impact(1.5)
