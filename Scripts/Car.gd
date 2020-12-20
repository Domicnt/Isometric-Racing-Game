extends KinematicBody2D

var velocity = Vector2()
var angular_momentum = 0;

const acceleration = Vector2(0,-5)
const reverse_acceleration = Vector2(0, -3);

const braking = 2;
const friction = .9;

const wheelDriftResistance = 5;
const maxSpeed = 500;
const max_wheel_angle = .00025;
const minWDrResStr = 0.05;
var car_angle = 0;

onready var sprite = get_node("../");

func change_sprite():
	sprite.position = position;
	var angle = ceil(fmod(car_angle*180/PI + 90 + 22.5, 360) / 45);
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

func turn_car(wheel_angle):
	angular_momentum += velocity.length() * wheel_angle;
	car_angle += angular_momentum;
	angular_momentum *= friction;

func _physics_process(_delta):
	var res = friction;
	
	#change angle of wheels, which later affect rotation
	var wheel_angle = 0;
	if Input.is_action_pressed('left'):
		wheel_angle -= max_wheel_angle;
	if Input.is_action_pressed('right'):
		wheel_angle += max_wheel_angle;
	
	#direct acceleration/deceleration
	if Input.is_action_pressed('forwards'):
		velocity += acceleration.rotated(car_angle);
	if Input.is_action_pressed("backwards"):
		velocity -= reverse_acceleration.rotated(car_angle);
	if Input.is_action_pressed("brake"):
		res += braking
		
	if velocity.length() > res:
		# angle between where car is facing and where it's moving
		var angle = velocity.angle()-(car_angle+PI/2)
		# strength of wheel resistance to drift, strongest if drift perpendicular to car facing
		var wDrResStr = sin(angle)
		if abs(wDrResStr) > minWDrResStr:
			velocity += Vector2(wDrResStr*wheelDriftResistance,0).rotated(car_angle)
		else: # if angle difference in minimal, then we discard
		# drift portion of velocity and leave the other making car move where it faces
			velocity *= abs(cos(angle))
		# applying traction and braking, if we brake
		velocity -= velocity.normalized() * res
		
		# limiting velocity to maxSpeed
		if velocity.length() > maxSpeed:
			velocity = velocity / velocity.length() * maxSpeed;
	else:
		velocity = Vector2()
	# let's not forget to save remainder of velocity, so it can be processed in future frames,
	# if we don't do it, then we will not be able to slide/drift and accelerate more
	velocity = move_and_slide(velocity);
	turn_car(wheel_angle);
	change_sprite();
