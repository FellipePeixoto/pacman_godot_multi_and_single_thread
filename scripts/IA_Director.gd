extends Node

export var warn_percent = 0.25

onready var Blinky = get_node("Blinky")
onready var Pinky = get_node("Pinky")
onready var Inky = get_node("Inky")
onready var Clyde = get_node("Clyde")

onready var pacman = get_parent().get_node("Pacman")
onready var tile_map = get_parent().get_node("Navigation2D/TileMap")
onready var level1 = get_parent()
var INIT_GHOSTS_EXECUTION_TIME
var blinky_thread : Thread = Thread.new()
var pinky_thread : Thread = Thread.new()
var inky_thread : Thread = Thread.new()
var clyde_thread : Thread = Thread.new()
var delta_time = 0
var still_running = true

func _ready():
	blinky_thread.start(self, "blink_set", 1)
	pinky_thread.start(self, "pinky_set", 1)
	inky_thread.start(self, "inky_set", 1)
	clyde_thread.start(self, "clyde_set", 1)
	pass

func _physics_process(delta):
	INIT_GHOSTS_EXECUTION_TIME = OS.get_ticks_usec()
	delta_time = delta

func blink_set(delta):
	yield(level1, "game_started")
	while (still_running):
		Blinky.call_deferred("behaviour", delta_time)
		Blinky.call_deferred("update_ghost",delta_time)
		yield(get_tree(), "idle_frame")

func pinky_set(delta):
	yield(level1, "game_started")
	while (still_running):
		Pinky.call_deferred("behaviour",delta_time)
		Pinky.call_deferred("update_ghost",delta_time)
		yield(get_tree(), "idle_frame")
	
func inky_set(delta):
	yield(level1, "game_started")
	while (still_running):
		Inky.call_deferred("behaviour",delta_time)
		Inky.call_deferred("update_ghost",delta_time)
		yield(get_tree(), "idle_frame")
	
func clyde_set(delta):
	yield(level1, "game_started")
	while (still_running):
		Clyde.call_deferred("behaviour",delta_time)
		Clyde.call_deferred("update_ghost",delta_time)
		yield(get_tree(), "idle_frame")

func _on_Pacman_get_big_dot():
	Blinky.set_ia_state(Blinky.STATE_RETREATING)
	Pinky.set_ia_state(Pinky.STATE_RETREATING)
	Inky.set_ia_state(Inky.STATE_RETREATING)
	Clyde.set_ia_state(Clyde.STATE_RETREATING)
	
func _exit_tree():
	if(blinky_thread.is_active()):
		blinky_thread.wait_to_finish()
	if(pinky_thread.is_active()):
		pinky_thread.wait_to_finish()
	if(inky_thread.is_active()):
		inky_thread.wait_to_finish()
	if(clyde_thread.is_active()):
		clyde_thread.wait_to_finish()
	pass

func _on_Level1_game_over():
	still_running = false
