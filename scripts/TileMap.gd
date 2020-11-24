extends TileMap

export var cells_horizontal = 28
export var cells_vertical = 31
var free_way_id = 22
var dot_id = 24
var big_dot_id = 25

onready var half_cell_size = get_cell_size()/2

func get_next_tile(pos, dir):
	var current_tile = world_to_map(pos)
	var next_tile = get_cellv(current_tile + dir)
	var next_tile_pos = Vector2()
	if (next_tile == free_way_id or next_tile == dot_id or next_tile == big_dot_id):
		next_tile_pos = map_to_world(current_tile + dir) + half_cell_size
		return {"result":true,"value":next_tile_pos}
	else:
		next_tile_pos = relocate(pos)
		return {"result":false,"value":next_tile_pos}
	
func relocate(pos):
	var tile = world_to_map(pos)
	return map_to_world(tile) + half_cell_size
