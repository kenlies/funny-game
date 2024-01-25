extends KinematicBody2D

export var speed = 200
export var max_enemy_cout = 100
var enemy_count = 0
onready var _animated_sprite = $AnimatedSprite
onready var _dashtimer = $DashTimer
onready var _dashcooldowntimer = $DashCoolDownTimer
var velocity = Vector2()
var enemy = preload("res://Enemy.tscn")
onready var _spawntimer = $SpawnTimer
onready var _camera = $Camera2D
onready var _area = $Area2D
var player = null

func get_input():
	velocity = Vector2()

	# handling stun
	if Input.is_action_pressed("ui_joke"):
		for i in _area.get_overlapping_bodies():
			if "Enemy" in i.name:
				i.stunned = true
				i._stun_timer.start()

	# handling dash and starting timers
	if Input.is_action_pressed("ui_dash") and _dashcooldowntimer.is_stopped():
		_dashtimer.start()
		speed = 500
		_dashcooldowntimer.start()
	
	# moving the player and playing animations
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
	speed = 100

# making the player move on every frame (if velocity is > 0)
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

# spawn an enemy
func _on_SpawnTimer_timeout():
	if enemy_count < max_enemy_cout:
		if player == null:
			player = get_parent().get_node("Player")
		var camera_center = _camera.get_camera_screen_center()
		# below has a bug that it doesn't spawn directly up, down, left or right
		var spawn_position = Vector2(choose_range(rand_range(camera_center.x - 200, camera_center.x - 100), rand_range(camera_center.x + 100, camera_center.x + 200)),
									choose_range(rand_range(camera_center.y - 200, camera_center.y - 100), rand_range(camera_center.y + 100, camera_center.y + 200)))
		
		var enemy_instance = enemy.instance()
		enemy_instance.position = spawn_position
		get_parent().add_child(enemy_instance)
		enemy_count += 1
	
func choose_range(val1, val2):
	if randf() < 0.5:
		return val1
	return val2

