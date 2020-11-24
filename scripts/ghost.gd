extends Area2D

export var speed = 7
export var curr_speed_factor = 1
export var speed_factor_retreating = 0.65
export var speed_factor_dead = 2
var rng = RandomNumberGenerator.new()
var change_dir_delay = 0
var next_tile_id
var next_tile
var dirs = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]

onready var retreat_timer = $Timer
onready var animation = $AnimationPlayer
onready var tile_map = get_parent().get_parent().get_node("Navigation2D/TileMap")
onready var level1 = get_parent().get_parent()
onready var director = get_parent()
onready var navigation2d = get_parent().get_parent().get_node("Navigation2D")

var current_dir = Vector2(0,0)
var next_dir = Vector2(0,0)
var next_position = Vector2(0,0)
var ia_input = Vector2(0,0)


var STATE_ATTACK = "ATTACK"
var STATE_RETREATING = "RETREATING"
var STATE_RETREATING_ENDING = "RETREATING_ENDING"
var STATE_DEAD = "DEAD"
var state = STATE_ATTACK

func _ready():
	retreat_timer.connect("timeout", self, "_on_Retreat_Timeout")

func behaviour(delta):
	if (level1.game_over):
		return
	match(state):
		STATE_ATTACK:
			attack(delta)
		STATE_RETREATING, STATE_RETREATING_ENDING:
			var remaining = retreat_timer.time_left / retreat_timer.wait_time
			if (remaining <= 0.3 and state == STATE_RETREATING):
				state = STATE_RETREATING_ENDING
			retreat(delta)
		STATE_DEAD:
			update_path_to_safe()
			var curr_tile = tile_map.world_to_map(global_position)
			if (curr_tile == Vector2(13,13)):
				set_ia_state(STATE_ATTACK)
			pass

func attack(delta):
	pass

func retreat(delta):
	if (change_dir_delay > 0):
		change_dir_delay -= delta
		return
	rng.randomize();
	var random_dir = rng.randi_range(1, 4)
	var new_random_dir
	match(random_dir):
		1:
			new_random_dir = Vector2(1,0)
		2:
			new_random_dir = Vector2(-1,0)
		3:
			new_random_dir = Vector2(0,1)
		4:
			new_random_dir = Vector2(0,-1)
	ia_input = new_random_dir
	change_dir_delay = 0.65

func update_ghost(delta):
	next_dir = ia_input
	next_position = tile_map.get_next_tile(position, current_dir)["value"]
	var calc_next_position = tile_map.get_next_tile(position, next_dir)
	if(calc_next_position["result"]):
		current_dir = next_dir
		next_position = calc_next_position["value"]
	if(current_dir != Vector2(0,0)):
		position = position.linear_interpolate(next_position , (speed * curr_speed_factor) * delta)
	anim_dir(current_dir)
		
func update_path_to_pacman():
	var path_to = navigation2d.get_simple_path(global_position, director.pacman.global_position, false)
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

func anim_dir(direction):
	match(state):
		STATE_ATTACK:
			match direction:
				Vector2(1,0):
					animation.play("right")
				Vector2(0,1):
					animation.play("down")
				Vector2(-1,0):
					animation.play("left")
				Vector2(0,-1):
					animation.play("up")
		STATE_RETREATING:
			animation.play("defend")
		STATE_RETREATING_ENDING:
			animation.play("defend_blink")
		STATE_DEAD:
			match direction:
				Vector2(1,0):
					animation.play("dead_right")
				Vector2(0,1):
					animation.play("dead_down")
				Vector2(-1,0):
					animation.play("dead_left")
				Vector2(0,-1):
					animation.play("dead_up")

func set_ia_state(in_state):
	match(in_state):
		STATE_ATTACK:
			curr_speed_factor = 1
		STATE_RETREATING:
			curr_speed_factor = speed_factor_retreating
			retreat_timer.start()
		STATE_DEAD:
			retreat_timer.stop()
			curr_speed_factor = 2
	state = in_state

func set_ia_input(input):
	ia_input = input.normalized()
	
func _on_Retreat_Timeout():
	set_ia_state(STATE_ATTACK)
	pass
