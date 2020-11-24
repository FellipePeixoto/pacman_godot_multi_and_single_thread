extends "res://scripts/ghost.gd"

var afraid = true

func attack(delta):
	if (is_pacman_front_of_me()):
		afraid = true
	var curr_tile = tile_map.world_to_map(global_position)
	if (afraid and curr_tile != Vector2(13,13)):
		update_path_to_safe()
	else:
		update_path_to_pacman()
		afraid = false
	pass

func is_pacman_front_of_me():
	if (global_position.distance_to(director.pacman.global_position) <= 20):
		return true
	return false
