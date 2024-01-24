extends KinematicBody2D

export (int) var speed = 300
onready var _animated_sprite = $AnimatedSprite
onready var _dashtimer = $DashTimer
onready var _dashcooldowntimer = $DashCoolDownTimer
var velocity = Vector2()
var enemy = preload("res://Enemy.tscn")
onready var _spawntimer = $SpawnTimer
var player = null

func get_input():
	velocity = Vector2()
	
	# handling dash and starting timers
	if Input.is_action_pressed("ui_space") and _dashcooldowntimer.is_stopped():
		_dashtimer.start()
		speed = 1200
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
	speed = 300

# making the player move on every frame (if velocity is > 0)
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func getPosOutsideCamera():
	var randx
	var randy
	var distance_outside_screen = 100
	var screensize
	

# spawn an enemy
func _on_SpawnTimer_timeout():
	if player == null:
		player = get_parent().get_node("Player")
	var viewport_rect = get_viewport().size
	print(viewport_rect)
	var spawn_position = Vector2(rand_range(-viewport_rect.x, 2 * viewport_rect.x), rand_range(-viewport_rect.y, 2 * viewport_rect.y))
	spawn_position = player.global_position + spawn_position
	var enemy_instance = enemy.instance()
	enemy_instance.position = spawn_position
	get_parent().add_child(enemy_instance)
