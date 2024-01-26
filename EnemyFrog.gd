extends KinematicBody2D

var player
var stunned = false
var jump = false
export var speed = 55
onready var _animated_sprite = $AnimatedSprite
onready var _jump_timer = $JumpTimer
onready var _stun_timer = $StunTimer
onready var _rigidbody2d = $RigidBody2D


func _physics_process(delta):
	# if we are detected, start the chase
	if stunned == true or jump:
		return 
	if player:
		var direction = (player.global_position - global_position).normalized()
		# flip the sprite based on left or right direction on the x axis
		if direction.x > 0:
			_animated_sprite.flip_h = false
		else:
			_animated_sprite.flip_h = true
		# move the enemy towards the player times speed
		move_and_slide(direction * speed)

func _on_JumpTimer_timeout():
	if not jump:
		jump = true
		_animated_sprite.set_frame(0)
	else:
		jump = false
		_animated_sprite.set_frame(1)


func _on_StunTimer_timeout():
	stunned = false

