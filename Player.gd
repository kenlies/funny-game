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
onready var _death_note_label = $CanvasLayer/DeathNote/Panel/Label
onready var _enemies = get_parent().get_node("Enemies")
var velocity = Vector2()
var enemy_frog = preload("res://EnemyFrog.tscn")
var enemy_kid = preload("res://EnemyKid.tscn")
var enemy_man = preload("res://EnemyMan.tscn")
var enemy_donut = preload("res://EnemyDonut.tscn")
var enemy_shroom = preload("res://EnemyShroom.tscn")
var enemy_ball = preload("res://EnemyBall.tscn")
var enemy_list = [
	enemy_man,
	enemy_kid,
	enemy_frog,
	enemy_donut,
	enemy_shroom,
	enemy_ball
]
var player = null
var joke_bubble = null
var alive = true
var enemy_count = 0 
var joke_count = 0
var laugh_count = 0

var spawnInterval = 0.3
var currentSpawnTime = 0
var bigCountDown = 14
var currentBigTime = 0
var currentEnemyMod = 1

func _ready():
	player = get_parent().get_node("Player")
	joke_bubble = get_parent().get_node("JokeBubble")

func get_input():
	velocity = Vector2()

	# handling stun
	if Input.is_action_pressed("ui_joke") and _jokecooldowntimer.is_stopped():
		joke_bubble.displayJoke()
		$SFXPlayer.play()
		_jokecooldowntimer.start()
		joke_count += 1
		for i in _stun_area.get_overlapping_bodies():
			if "Enemy" in i.name:
				laugh_count += 1
				i.stunned = true
				i._stun_timer.start()

	# handling dash and starting timers
	if Input.is_action_pressed("ui_dash") and _dashcooldowntimer.is_stopped():
		_dashtimer.start()
		speed = 300
		$CollisionShape2D.scale.x = 0.3
		$CollisionShape2D.scale.y = 0.3
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

	# set animated sprite
	if not _dashtimer.is_stopped():
		_animated_sprite.play("player_roll")
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		_animated_sprite.play("player_walk")
	else:
		_animated_sprite.stop()
		_animated_sprite.frame = 0
	velocity = velocity.normalized() * speed

func get_endscr_input():
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://Main.tscn")

func spawnEnemy():
	randomize()
	var enemy_instance = (enemy_list[randi() % int(currentEnemyMod)]).instance()
	enemy_instance.player = player
	enemy_instance.position = h.getRandomSpawnPos(_camera.get_camera_screen_center())
	_enemies.add_child(enemy_instance)

# making the player move on every frame, checking if player died & spawning enemies
func _physics_process(delta):
	print(enemy_count)

	if alive:
		print(spawnInterval)
		currentSpawnTime += delta
		currentBigTime += delta
		if currentSpawnTime >= spawnInterval:
			spawnEnemy()
			enemy_count += 1
			currentSpawnTime = 0
		if currentBigTime >= bigCountDown:
			if spawnInterval >= 0.075:
				if (currentEnemyMod < enemy_list.size()):
					currentEnemyMod += 0.7
				spawnInterval -= 0.025
			currentBigTime = 0
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
		_animated_sprite.stop()
		_animated_sprite.frame = 0
		joke_bubble.hideJoke()
		_death_note_label.text = "You made people laugh " + str(laugh_count) + " times\n" + "Time: " + str(Time.get_ticks_msec() / 1000) + "s\n" + "Jokes told: " + str(joke_count)
		$CanvasLayer/DeathNote.set_visible(true)

func checkDeathConditions():
	if ((len(_death_area.get_overlapping_bodies()) > 10 and _death_validity_timer.is_stopped()) or 
			((player.position.x > 1490 or player.position.x < -1490 or player.position.y > 985 or player.position.y < -985) and 
			len(_death_area.get_overlapping_bodies()) > 8 and _death_validity_timer.is_stopped())):
		return true
	return false

func _on_DashTimer_timeout():
	speed = 100
	$CollisionShape2D.scale.x = 1.0
	$CollisionShape2D.scale.y = 1.0
