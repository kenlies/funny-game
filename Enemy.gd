extends KinematicBody2D

var player
var speed = 100
onready var _animated_sprite = $AnimatedSprite
	
func _process(delta):
	# if we are detected, start the chase
	if player:
		var direction = (player.global_position - global_position).normalized()
		# flip the sprite based on left or right direction on the x axis
		if direction.x > 0:
			_animated_sprite.flip_h = true
		else:
			_animated_sprite.flip_h = false
		_animated_sprite.play("default")
		# move the enemy towards the player times speed
		move_and_slide(direction * speed)

func _on_PlayerDetection_body_entered(body):
	# player is initially null, set it to body when detected
	if body.name == "Player":
		player = body
		
