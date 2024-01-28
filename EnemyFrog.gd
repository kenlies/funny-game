extends KinematicBody2D

const HelperFuncs = preload("res://HelperFunctions.gd")
var h = HelperFuncs.new()

var player # set in player node
var stunned = false
var jump = false
export var speed = 55
onready var _animated_sprite = $AnimatedSprite
onready var _jump_timer = $JumpTimer
onready var _stun_timer = $StunTimer


func _physics_process(delta):
	if jump:
		return 
	if stunned == true:
		_animated_sprite.play("laugh")
		return
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
	h.checkPositionOutOfView(self, player)

func _on_JumpTimer_timeout():
	if not jump:
		jump = true
		_animated_sprite.set_frame(0)
	else:
		jump = false
		_animated_sprite.set_frame(1)


func _on_StunTimer_timeout():
	stunned = false
	_animated_sprite.stop()
	_animated_sprite.animation = "default"

