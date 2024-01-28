extends KinematicBody2D

const HelperFuncs = preload("res://HelperFunctions.gd")
var h = HelperFuncs.new()

var player # set in player node
var stunned = false
export var speed = 40
onready var _animated_sprite = $AnimatedSprite
onready var _stun_timer = $StunTimer
var 	sprite_variant = randi() % 4

func _physics_process(delta):
	if stunned == true:
		_animated_sprite.play("laugh" + str(sprite_variant))
		return
	else:
		_animated_sprite.play("default" + str(sprite_variant))
	if player:
		var direction = (player.global_position - global_position).normalized()
		if not player.alive:
			direction.x *= -0.25
			direction.y *= -0.25
		# flip the sprite based on left or right direction on the x axis
		if direction.x > 0:
			_animated_sprite.flip_h = false
		else:
			_animated_sprite.flip_h = true
		# move the enemy towards the player times speed
		move_and_slide(direction * speed)

	# destroy enemy if its too far away from the view
	h.checkPositionOutOfView(self, player)

func _on_StunTimer_timeout():
	stunned = false
