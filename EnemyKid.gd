extends KinematicBody2D

export var speed = 70
var velocity = Vector2.ZERO
var player
var random_num
var target

enum {
	SURROUND,
	HUG,
}

var state = SURROUND

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	random_num = rng.randf()
	

func _physics_process(delta):
	match state:
		SURROUND:
			move(get_circle_position(random_num), delta)
		HUG:
			move(player.global_position, delta)

func move(target, delta):
	var direction = (target - global_position).normalized()
	var desired_velocity = direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	velocity = move_and_slide(velocity)

func get_circle_position(random):
	var circle_center = player.global_position
	var radius = 30
	var angle = random * PI * 2;
	var x = circle_center.x + cos(angle) * radius;
	var y = circle_center.y + sin(angle) * radius;
	return Vector2(x, y)

