extends KinematicBody2D

export var speed = 200
export var max_enemy_cout = 100
onready var _animated_sprite = $AnimatedSprite
onready var _dashtimer = $DashTimer
onready var _dashcooldowntimer = $DashCoolDownTimer
onready var _jokecooldowntimer = $JokeCoolDownTimer
onready var _spawntimer = $SpawnTimer
onready var _camera = $Camera2D
onready var _stun_area = $StunArea
onready var _death_area = $DeathArea
onready var _death_validity_timer = $DeathValidityTimer
onready var _death_note = $DeathNote/Label
var velocity = Vector2()
var enemy_frog = preload("res://EnemyFrog.tscn")
var enemy_kid = preload("res://EnemyKid.tscn")
var player = null
var enemy_count = 0
var joke_count = 0

func _ready():
	player = get_parent().get_node("Player")

func get_input():
	velocity = Vector2()

	# handling stun
	if Input.is_action_pressed("ui_joke") and _jokecooldowntimer.is_stopped():
		_jokecooldowntimer.start()
		joke_count += 1
		for i in _stun_area.get_overlapping_bodies():
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

# making the player move on every frame (if velocity is > 0) and checking if player died
func _physics_process(delta):
	get_input()
	if len(_death_area.get_overlapping_bodies()) > 10 and _death_validity_timer.is_stopped():
		print("timer start")
		_death_validity_timer.start()
	velocity = move_and_slide(velocity)

# check if player actually died
func _on_DeathValidityTimer_timeout():
	if len(_death_area.get_overlapping_bodies()) > 10:
		print("death")
		_death_note.text = "You Died Bitch\nJokes told: " + str(joke_count)
		$DeathNote.set_visible(true)

func _on_DashTimer_timeout():
	speed = 100

# spawn an enemy
func _on_SpawnTimer_timeout():
	if enemy_count < max_enemy_cout:
		# camera center
		var cam_cen = _camera.get_camera_screen_center()
		# - calculates the spawn positions so that enemies spawn outside of camera view
		# basically I take two vectors, the first one wil have the x coordinate limited, and free y cordinate
		# the second will have y coordinate limited, and free x cordinate, then we just choose randomly with choose range
		var spawn_position = rand_choose(Vector2(rand_choose(rand_range(cam_cen.x - 200, cam_cen.x - 190), 
															rand_range(cam_cen.x + 190, cam_cen.x + 200)), 
															rand_range(cam_cen.y - 200, cam_cen.y + 200)), 
															Vector2(rand_range(cam_cen.x - 200, cam_cen.x + 200),
															rand_choose(rand_range(cam_cen.y - 200, cam_cen.y - 190), 
															rand_range(cam_cen.y + 190, cam_cen.y + 200))))
		var enemy_instance = enemy_frog.instance()
		enemy_instance.player = player
		enemy_instance.position = spawn_position
		get_parent().add_child(enemy_instance)
		enemy_count += 1
	
func rand_choose(val1, val2):
	if randf() < 0.5:
		return val1
	return val2

func _on_StunArea_body_entered(body):
	if "Kid" in body.name:
		body._hug_timer.start()
