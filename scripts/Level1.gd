extends Node2D

signal game_over

onready var pacman = get_node("Pacman")
onready var director = get_node("Director")
onready var blinky = get_node("Director/Blinky")
onready var pinky = get_node("Director/Pinky")
onready var inky = get_node("Director/Inky")
onready var clyde = get_node("Director/Clyde")
onready var label_right = get_node("Label")
onready var label_stats = get_node("Stats")
onready var navigation2d : Navigation2D = $Navigation2D
var msg_txt = "PRESS SPACE BAR\nTO START"
var game_over = true
var old_scene = false
var INIT_EXECUTION_TIME

func _ready():
	pass

func get_path_to_pacman(ghost : Vector2):
	return navigation2d.get_simple_path(ghost, pacman.global_position, false)
	
func _physics_process(delta):
	if (game_over and Input.is_action_just_pressed("ui_select")):
		game_over = false
		if (old_scene):
			get_tree().reload_current_scene()
		old_scene = true
		msg_txt = "PRESS SPACE BAR\nTO PLAY AGAIN"
	if (game_over):
		label_right.text = msg_txt
		return
	if (pacman.overlaps_area(blinky) and blinky.state == blinky.STATE_ATTACK):
		emit_signal("game_over")
		game_over = true
	elif(pacman.overlaps_area(blinky) and (blinky.state == blinky.STATE_RETREATING or blinky.state == blinky.STATE_RETREATING_ENDING)):
		blinky.set_ia_state(blinky.STATE_DEAD)
		pacman.score += 200
		label_stats.text = "SCORE: %d"%[pacman.score]
	if (pacman.overlaps_area(pinky) and pinky.state == pinky.STATE_ATTACK):
		emit_signal("game_over")
		game_over = true
	elif(pacman.overlaps_area(pinky) and (pinky.state == pinky.STATE_RETREATING or pinky.state == pinky.STATE_RETREATING_ENDING)):
		pinky.set_ia_state(pinky.STATE_DEAD)
		pacman.score += 200
		label_stats.text = "SCORE: %d"%[pacman.score]
	if (pacman.overlaps_area(inky) and inky.state == inky.STATE_ATTACK):
		emit_signal("game_over")
		game_over = true
	elif(pacman.overlaps_area(inky) and (inky.state == inky.STATE_RETREATING or inky.state == inky.STATE_RETREATING_ENDING)):
		inky.set_ia_state(inky.STATE_DEAD)
		pacman.score += 200
		label_stats.text = "SCORE: %d"%[pacman.score]
	if (pacman.overlaps_area(clyde) and clyde.state == clyde.STATE_ATTACK):
		emit_signal("game_over")
		game_over = true
	elif(pacman.overlaps_area(clyde) and (clyde.state == clyde.STATE_RETREATING or clyde.state == clyde.STATE_RETREATING_ENDING)):
		clyde.set_ia_state(clyde.STATE_DEAD)
		pacman.score += 200
		label_stats.text = "SCORE: %d"%[pacman.score]
	INIT_EXECUTION_TIME = OS.get_ticks_usec()
