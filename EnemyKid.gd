extends KinematicBody2D

const HelperFuncs = preload("res://HelperFunctions.gd")
var h = HelperFuncs.new()

onready var _stun_timer = $StunTimer
onready var _hug_timer = $HugTimer
var wants_to_hug = false
export var speed = 80
var stunned = false
var velocity = Vector2.ZERO
var player # set in player node
var random_num
var target

# random number generation
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	random_num = rng.randf()
	

func _physics_process(delta):
	if stunned == true:
		return
	if not wants_to_hug:
		move(get_circle_position(random_num), delta)
	else:
		move(player.global_position, delta)
	h.checkPositionOutOfView(self, player)

# move the kid and add steering to make movement (?smoother?)
func move(target, delta):
	var direction = (target - global_position).normalized()
	if not player.alive:
		direction.x *= -0.25
		direction.y *= -0.25
	var desired_velocity = direction * speed
	var steering = (desired_velocity - velocity) * delta * 0.5
	velocity += steering
	velocity = move_and_slide(velocity)

# get a random position in a circle around the player
func get_circle_position(random):
	var circle_center = player.global_position
	var radius = 80
	var angle = random * PI * 2;
	var x = circle_center.x + cos(angle) * radius;
	var y = circle_center.y + sin(angle) * radius;
	return Vector2(x, y)

func _on_StunTimer_timeout():
	stunned = false

func _on_HugTimer_timeout():
	wants_to_hug = true
