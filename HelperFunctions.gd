extends Node

func checkPositionOutOfView(enemy, player):
	if (enemy.global_position.x > player.global_position.x + 370 or enemy.global_position.x < player.global_position.x - 360
		or enemy.global_position.y > player.global_position.y + 370 or enemy.global_position.y < player.global_position.y - 360):
		enemy.queue_free()
		player.enemy_count -= 1
