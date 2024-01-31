extends KinematicBody2D

const HelperFuncs = preload("res://HelperFunctions.gd")
var h = HelperFuncs.new()

var player # set in player node
var stunned = false
var jump = false
export var speed = 30
onready var _animated_sprite = $AnimatedSprite
onready var _stun_timer = $StunTimer

func _physics_process(delta):
	if stunned == true or jump:
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
			_animated_sprite.flip_h = true
		else:
			_animated_sprite.flip_h = false
		# move the enemy towards the player times speed
		move_and_slide(direction * speed)

	# destroy enemy if its too far away from the view
	h.checkPositionOutOfView(self, player)

func _on_StunTimer_timeout():
	stunned = false