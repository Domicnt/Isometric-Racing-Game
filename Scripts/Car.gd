extends RigidBody2D

const engine_power = 500;
const reverse_engine_power = 300;
const braking_force = 1;
const max_wheel_angle = 8;

const traction = .9;

onready var sprite = get_node("../");
func change_sprite():
	sprite.position = position;
	var angle = ceil(fposmod(rotation*180/PI + 180 + 22.5, 360) / 45);
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

func steer():
	#turning the front wheel
	var wheel_angle = 0;
	if Input.is_action_pressed('left'):
		wheel_angle -= max_wheel_angle;
	if Input.is_action_pressed('right'):
		wheel_angle += max_wheel_angle;
	
	#check if the car is moving forwards or backwards, then turn based on wheel angle
	if linear_velocity.normalized().dot(Vector2(cos(rotation), sin(rotation))) > 0:
		add_torque(wheel_angle * linear_velocity.length());
	else:
		add_torque(-wheel_angle * linear_velocity.length());

func apply_forces():
	#reset active forces
	applied_force = Vector2(0, 0);
	applied_torque = 0;
	
	#drag
	linear_velocity *= .99;
	angular_velocity *= .9;
	
	#amount that the wheels slip, more if accelerating / braking, etc
	var slip = traction;
	
	#apply engine force at the rear wheel if accelerating
	if Input.is_action_pressed('forwards'):
		add_central_force(transform.x * engine_power);
		#add_force(back_wheel, transform.x * engine_power);
		slip *= 2;
	if Input.is_action_pressed("backwards"):
		add_central_force(transform.x * -reverse_engine_power);
		#add_force(back_wheel, transform.x * -reverse_engine_power);
		slip *= 2;
	
	# slow car and increase slipping if braking
	if Input.is_action_pressed('brake'):
		slip *= 2;
		add_central_force(-linear_velocity * braking_force);
	
	var diff = fposmod(rotation - linear_velocity.angle(), TAU);
	if Input.is_action_pressed('print'):
		print(diff);
	diff = (PI - abs(diff - PI)) / PI;
	
	add_central_force(-linear_velocity * diff * slip * 1.5);

func _ready():
	gravity_scale = 0;

func _physics_process(_delta):
	apply_forces();
	steer();
	change_sprite();
