extends KinematicBody2D


onready var sprite = get_node("../");

var wheel_base = 16
var steering_angle = deg2rad(15)
var steering_angle_slow = deg2rad(15)
var engine_power = 300
var braking = -250
var max_speed = 650
var max_speed_reverse = 250
var friction = -0.8
var drag = -0.001
var traction_fast = 0.01
var traction_slow = 0.05
var slip_speed = 400

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var steer_angle

func get_input():
	var turn = 0
	if Input.is_action_pressed("right"):
		turn += 1
	if Input.is_action_pressed("left"):
		turn -= 1
	steer_angle = turn * steering_angle
	if velocity.length() < slip_speed:
		steer_angle = turn * steering_angle_slow
	if Input.is_action_pressed("forwards"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("backwards"):
		acceleration = transform.x * braking

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input();
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
	change_sprite();
	
func change_sprite():
	sprite.position = position;
	var angle = ceil(fmod(rotation_degrees + 180 + 22.5, 360) / 45);
	match angle:
		1.0:
			sprite.animation = "left";
			sprite.flip_h = false;
		2.0:
			sprite.animation = "left_up";
			sprite.flip_h = false;
		3.0:
			sprite.animation = "up";
		4.0:
			sprite.animation = "left_up";
			sprite.flip_h = true;
		5.0:
			sprite.animation = "left";
			sprite.flip_h = true;
		6.0:
			sprite.animation = "left_down";
			sprite.flip_h = true;
		7.0:
			sprite.animation = "down";
		8.0:
			sprite.animation = "left_down";
			sprite.flip_h = false;
	
func apply_friction():
	var f = velocity * friction
	var d = velocity * velocity.length() * drag
	if velocity.length() < 100:
		f *= 3
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	acceleration += d + f

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()

	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
#	if d > 0.1 and d < 1 and velocity.length() > slip_speed:
#		$SkidLeft.emitting = true
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	elif d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
