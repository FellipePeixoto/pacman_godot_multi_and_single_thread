extends Area2D

export var speed = 8
var next_dir = Vector2(1,0)
var current_dir = Vector2(1,0)
var next_position = Vector2()
signal on_current_dir_change
signal get_big_dot
var alive = true
var backoff_time
var score = 0

onready var wall = get_parent().get_node("Navigation2D").get_node("TileMap")
onready var animation = $AnimationPlayer
onready var level1 = get_parent()

func _ready():
	current_dir = Vector2(1,0)
	next_dir = Vector2(1,0)
	animation.play("pacman_right")

func _physics_process(delta):
	if (level1.game_over):
		alive = false
		return
	if (Input.is_action_pressed("ui_down")):
		next_dir = Vector2(0,1)
	if (Input.is_action_pressed("ui_up")):
		next_dir = Vector2(0,-1)
	if (Input.is_action_pressed("ui_right")):
		next_dir = Vector2(1,0)
	if (Input.is_action_pressed("ui_left")):
		next_dir = Vector2(-1,0)
	
	next_position = wall.get_next_tile(position, current_dir)["value"]
	var calc_next_position = wall.get_next_tile(position, next_dir)
	if(calc_next_position["result"] and current_dir != next_dir):
		current_dir = next_dir
		emit_signal("on_current_dir_change", current_dir)
		next_position = calc_next_position["value"]
		
	anim_dir(current_dir)
		
	if(current_dir != Vector2(0,0)):
		position = position.linear_interpolate(next_position , speed * delta)
		#position += (next_position - position).normalized() * speed * delta
	eat()

func anim_dir(direction):
	match direction:
		Vector2(1,0):
			animation.play("pacman_right")
		Vector2(0,1):
			animation.play("pacman_down")
		Vector2(-1,0):
			animation.play("pacman_left")
		Vector2(0,-1):
			animation.play("pacman_up")
			
func eat():
	var curr_tile = wall.world_to_map(global_position)
	var curr_tile_id = wall.get_cell(curr_tile.x, curr_tile.y)
	if (curr_tile_id == wall.dot_id):
		wall.set_cell(curr_tile.x, curr_tile.y, 22)
		score += 10
		level1.label_stats.text = "SCORE: %d"%[score]
		level1.all_dots_count -= 1
		return
	if (curr_tile_id == wall.big_dot_id):
		wall.set_cell(curr_tile.x, curr_tile.y, 22)
		score += 50
		level1.label_stats.text = "SCORE: %d"%[score]
		emit_signal("get_big_dot")
		level1.all_dots_count -= 1
		return
