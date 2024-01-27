extends Node

# used in enemy scripts
func checkPositionOutOfView(enemy, player):
	if (enemy.global_position.x > player.global_position.x + 500 or enemy.global_position.x < player.global_position.x - 500
		or enemy.global_position.y > player.global_position.y + 370 or enemy.global_position.y < player.global_position.y - 360):
		enemy.queue_free()
		player.enemy_count -= 1

# used in player script
func rand_choose(val1, val2):
	if randf() < 0.5:
		return val1
	return val2

# used in player script
# - calculates the spawn positions so that enemies spawn outside of camera view
# basically I take two vectors, the first one wil have the x coordinate limited, and free y cordinate
# the second will have y coordinate limited, and free x cordinate, then we just choose randomly with choose range
func getRandomSpawnPos(cam_cen):
	var spawn_position = rand_choose(Vector2(rand_choose(rand_range(cam_cen.x - 360, cam_cen.x - 320), 
														rand_range(cam_cen.x + 320, cam_cen.x + 360)), 
														rand_range(cam_cen.y - 360, cam_cen.y + 360)), 
														Vector2(rand_range(cam_cen.x - 360, cam_cen.x + 360),
														rand_choose(rand_range(cam_cen.y - 360, cam_cen.y - 320),
														rand_range(cam_cen.y + 320, cam_cen.y + 360))))
	return spawn_position
