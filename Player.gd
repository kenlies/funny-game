extends KinematicBody2D

export (int) var speed = 300
onready var _animated_sprite = $AnimatedSprite
onready var _dashtimer = $DashTimer
onready var _dashcooldowntimer = $DashCoolDownTimer
var velocity = Vector2()

func get_input():
	velocity = Vector2()

	if Input.is_action_pressed("ui_space") and _dashcooldowntimer.is_stopped():
		_dashtimer.start()
		speed = 1200
		_dashcooldowntimer.start()

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		_animated_sprite.play("kurwa")
	else:
		_animated_sprite.stop()
	velocity = velocity.normalized() * speed

func _on_DashTimer_timeout():
	speed = 300

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
