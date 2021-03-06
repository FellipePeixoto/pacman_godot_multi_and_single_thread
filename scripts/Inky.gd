extends "res://scripts/ghost.gd"

var time_until_change = 0
var ran_gen = RandomNumberGenerator.new()
var ran_gen_float = RandomNumberGenerator.new()
var target_pos = Vector2(0,0)
var choose
var afraid = false

func _ready():
	ran_gen.randomize()
	choose = ran_gen.randi_range(0,2)
	ran_gen_float.randomize()
	time_until_change = ran_gen_float.randf_range(3,10)

func attack(delta):
	if (time_until_change > 0):
		match (choose):
			0:
				update_path_to_pacman()
				pass
			1:
				if (is_pacman_front_of_me()):
					afraid = true
				var curr_tile = tile_map.world_to_map(global_position)
				if (afraid and curr_tile != Vector2(13,13)):
					update_path_to_safe()
				else:
					update_path_to_pacman()
					afraid = false
				pass
			2:
				update_ambush_to_pacman()
				pass
		time_until_change -= delta
		return
	ran_gen.randomize()
	choose = ran_gen.randi_range(0,2)
	ran_gen_float.randomize()
	time_until_change = ran_gen_float.randf_range(3,10)
	pass

func is_pacman_front_of_me():
	if (global_position.distance_to(director.pacman.global_position) <= 20):
		return true
	return false

func update_path_to_safe():
	var path_to = navigation2d.get_simple_path(global_position, tile_map.map_to_world(Vector2(13,13)), false)
	if (path_to.size() > 1):
		var i = 0
		var curr_tile = tile_map.world_to_map(global_position)
		var tile_path = Vector2()
		var tile_target_dir = Vector2()
		while (tile_target_dir == Vector2(0,0) and i < path_to.size()):
			tile_path = tile_map.world_to_map(path_to[i])
			tile_target_dir = tile_path - curr_tile
			i+=1
		ia_input = tile_target_dir
		ia_input = ia_input.normalized()


func _on_Pacman_on_current_dir_change(pacman_current_dir):
	if (pacman_on_h() or pacman_on_v()):
		target_pos = Vector2(0,0)
		return
	target_pos = calc_predict(pacman_current_dir * -1, director.pacman.global_position)
	
func pacman_on_v():
	var pacman_curr_tile = tile_map.world_to_map(director.pacman.global_position)
	var up = false
	var down = false
	var curr_tile = tile_map.world_to_map(global_position)
	var next_tile = Vector2(curr_tile.x, curr_tile.y)
	var next_tile_id = tile_map.get_cell(next_tile.x, next_tile.y)
	while ((next_tile_id == tile_map.free_way_id or next_tile_id == tile_map.dot_id or next_tile_id == tile_map.dot_id) and !up):
		if (pacman_curr_tile == next_tile):
			up = true
		next_tile = Vector2(next_tile.x, next_tile.y - 1)
		next_tile_id = tile_map.get_cell(next_tile.x, next_tile.y)
	next_tile = Vector2(curr_tile.x, curr_tile.y + 1)
	next_tile_id = tile_map.get_cell(next_tile.x, next_tile.y)
	while ((next_tile_id == tile_map.free_way_id or next_tile_id == tile_map.dot_id or next_tile_id == tile_map.dot_id) and !down):
		if (pacman_curr_tile == next_tile):
			down = true
		next_tile = Vector2(next_tile.x, next_tile.y + 1)
		next_tile_id = tile_map.get_cell(next_tile.x, next_tile.y)
	return up or down
	
func pacman_on_h():
	var pacman_curr_tile = tile_map.world_to_map(director.pacman.global_position)
	var right = false
	var left = false
	var curr_tile = tile_map.world_to_map(global_position)
	var next_tile = Vector2(curr_tile.x, curr_tile.y)
	var next_tile_id = tile_map.get_cell(next_tile.x, next_tile.y)
	while ((next_tile_id == tile_map.free_way_id or next_tile_id == tile_map.dot_id or next_tile_id == tile_map.dot_id) and !right):
		if (pacman_curr_tile == next_tile):
			right = true
		next_tile = Vector2(next_tile.x + 1, next_tile.y)
		next_tile_id = tile_map.get_cell(next_tile.x, next_tile.y)
	next_tile = Vector2(next_tile.x, next_tile.y)
	next_tile_id = tile_map.get_cell(next_tile.x, next_tile.y)
	while ((next_tile_id == tile_map.free_way_id or next_tile_id == tile_map.dot_id or next_tile_id == tile_map.dot_id) and !left):
		if (pacman_curr_tile == next_tile):
			left = true
		next_tile = Vector2(next_tile.x - 1, next_tile.y)
		next_tile_id = tile_map.get_cell(next_tile.x, next_tile.y)
	return right or left
	
func calc_predict(recursion_dir, recursion_position):
	if (recursion_dir == Vector2(0,0)):
		return director.pacman.global_position
	var recursion_curr_tile = tile_map.world_to_map(recursion_position)
	var my_position_tile = tile_map.world_to_map(global_position)
	var next_tile = recursion_curr_tile + recursion_dir * -1
	var next_tile_id = director.tile_map.get_cell(next_tile.x, next_tile.y)
	if (next_tile_id != tile_map.free_way_id and next_tile_id != tile_map.dot_id and next_tile_id != tile_map.big_dot_id):
		return recursion_position
	else:
		return calc_predict(recursion_dir, tile_map.map_to_world(next_tile))

func update_ambush_to_pacman():
	var path_to
	if (target_pos == Vector2(0,0)):
		path_to = navigation2d.get_simple_path(global_position, director.pacman.global_position, false)
	else:
		path_to = navigation2d.get_simple_path(global_position, target_pos, false)
	if (path_to.size() > 1):
		var i = 0
		var curr_tile = tile_map.world_to_map(global_position)
		var tile_path = Vector2()
		var tile_target_dir = Vector2()
		while (tile_target_dir == Vector2(0,0) and i < path_to.size()):
			tile_path = tile_map.world_to_map(path_to[i])
			tile_target_dir = tile_path - curr_tile
			i+=1
		ia_input = tile_target_dir
		ia_input = ia_input.normalized()
