extends KinematicBody2D

const HelperFuncs = preload("res://HelperFunctions.gd")
var h = HelperFuncs.new()

var player # set in player node
var stunned = false
var wait = false
var jump = false
export var speed = 30
onready var _animated_sprite = $AnimatedSprite
onready var _stun_timer = $StunTimer

onready var sprite_variants_count = _animated_sprite.frames.get_animation_names().size() / 2
onready var 	sprite_variant = randi() % sprite_variants_count

func _physics_process(delta):
	if wait == true:
		return
	if stunned == true or jump:
		_animated_sprite.play("laugh" + str(sprite_variant))
		return
	else:
		_animated_sprite.play("default" + str(sprite_variant))
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
		if (get_slide_count() >= 4):
			wait = true
			$WaitTimer.start(rand_range(0.3, 1.2))		

	# destroy enemy if its too far away from the view
	h.checkPositionOutOfView(self, player)

func _on_StunTimer_timeout():
	stunned = false

func _on_WaitTimer_timeout():
	wait = false
