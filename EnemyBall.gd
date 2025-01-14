extends KinematicBody2D

const HelperFuncs = preload("res://HelperFunctions.gd")
var h = HelperFuncs.new()

var player # set in player node
var stunned = false
var wait = false
export var speed = 60
onready var _animated_sprite = $AnimatedSprite
onready var _stun_timer = $StunTimer

func _physics_process(_delta):
	if wait == true:
		return
	if stunned == true:
		_animated_sprite.play("laugh")
		return
	else:
		_animated_sprite.play("default")
	if player:
		var direction = (player.global_position - global_position).normalized()
		if not player.alive:
			direction.x *= -0.05
			direction.y *= -0.05
		# flip the sprite based on left or right direction on the x axis
		if direction.x > 0:
			_animated_sprite.flip_h = false
		else:
			_animated_sprite.flip_h = true
		# move the enemy towards the player times speed
		move_and_slide(direction * speed)
		if (get_slide_count() >= 4):
			wait = true
			$WaitTimer.start(rand_range(0.3, 0.8))

	# destroy enemy if its too far away from the view
	h.checkPositionOutOfView(self, player)

func _on_StunTimer_timeout():
	stunned = false

func _on_WaitTimer_timeout():
	wait = false
