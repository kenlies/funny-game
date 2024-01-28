extends KinematicBody2D

const HelperFuncs = preload("res://HelperFunctions.gd")
var h = HelperFuncs.new()

export var speed = 100
export var max_enemy_count = 500
onready var _animated_sprite = $AnimatedSprite
onready var _dashtimer = $DashTimer
onready var _dashcooldowntimer = $DashCoolDownTimer
onready var _jokecooldowntimer = $JokeCoolDownTimer
onready var _spawntimer = $SpawnTimer
onready var _camera = $Camera2D
onready var _stun_area = $StunArea
onready var _death_area = $DeathArea
onready var _death_validity_timer = $DeathValidityTimer
onready var _death_note_label = $CanvasLayer/DeathNote/Label
onready var _enemies = get_parent().get_node("Enemies")
var velocity = Vector2()
var enemy_frog = preload("res://EnemyFrog.tscn")
var enemy_kid = preload("res://EnemyKid.tscn")
var enemy_man = preload("res://EnemyMan.tscn")
var player = null
var alive = true
var enemy_count = 0 
var joke_count = 0

var spawnInterval = 0.025
var currentSpawnTime = 0
var bigCountDown = 2
var currentBigTime = 0

func _ready():
	player = get_parent().get_node("Player")

func get_input():
	velocity = Vector2()

	# handling stun
	if Input.is_action_pressed("ui_joke") and _jokecooldowntimer.is_stopped():
		$CanvasLayer/JokeBubble.displayJoke()
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
		_animated_sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		_animated_sprite.flip_h = true
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		_animated_sprite.play("player_walk")
	else:
		_animated_sprite.stop()
		_animated_sprite.frame = 0
	velocity = velocity.normalized() * speed

func get_endscr_input():
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://Main.tscn")

func spawnEnemy():
	var enemy_instance = enemy_kid.instance()
	enemy_instance.player = player
	enemy_instance.position = h.getRandomSpawnPos(_camera.get_camera_screen_center())
	_enemies.add_child(enemy_instance)

# making the player move on every frame (if velocity is > 0) and checking if player died
func _physics_process(delta):
	
	print(spawnInterval)
	
	currentSpawnTime += delta
	currentBigTime += delta
	
	if currentSpawnTime >= spawnInterval and enemy_count < max_enemy_count:
		spawnEnemy()
		enemy_count += 1
		currentSpawnTime = 0
	if currentBigTime >= bigCountDown:
		if spawnInterval > 0.05:
			spawnInterval -= 0.025
		currentBigTime = 0
	
	print(enemy_count)

	if alive:
		get_input()
		if checkDeathConditions():
			print("timer start")
			_death_validity_timer.start()
		velocity = move_and_slide(velocity)
	else:
		get_endscr_input()

# check if player actually died
func _on_DeathValidityTimer_timeout():
	if checkDeathConditions():
		print("death")
		alive = false
		_death_note_label.text = "You Died Bitch\nTime alive: " + str(Time.get_ticks_msec() / 1000) + "s\n" + "Jokes told: " + str(joke_count)
		$CanvasLayer/DeathNote.set_visible(true)

func checkDeathConditions():
	if ((len(_death_area.get_overlapping_bodies()) > 10 and _death_validity_timer.is_stopped()) or 
			((player.position.x > 1490 or player.position.x < -1490 or player.position.y > 985 or player.position.y < -985) and 
			len(_death_area.get_overlapping_bodies()) > 8 and _death_validity_timer.is_stopped())):
		return true
	return false

func _on_DashTimer_timeout():
	speed = 100
