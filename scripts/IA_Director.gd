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
var start_threads = false
var blinky_thread : Thread = Thread.new()
var pinky_thread : Thread = Thread.new()
var inky_thread : Thread = Thread.new()
var clyde_thread : Thread = Thread.new()

func _physics_process(delta):
	INIT_GHOSTS_EXECUTION_TIME = OS.get_ticks_usec()
	if (start_threads):
		blinky_thread.start(self, "blink_set", delta)
		pinky_thread.start(self, "pinky_set", delta)
		inky_thread.start(self, "inky_set", delta)
		clyde_thread.start(self, "clyde_set", delta)
		start_threads = false
		pass

func blink_set(delta):
	while (!level1.game_over):
		Blinky.call_deferred("behaviour", delta)
		Blinky.call_deferred("update_ghost",delta)
		yield(get_tree(), "idle_frame")

func pinky_set(delta):
	while (!level1.game_over):
		Pinky.call_deferred("behaviour",delta)
		Pinky.call_deferred("update_ghost",delta)
		yield(get_tree(), "idle_frame")
	
func inky_set(delta):
	while (!level1.game_over):
		Inky.call_deferred("behaviour",delta)
		Inky.call_deferred("update_ghost",delta)
		yield(get_tree(), "idle_frame")
	
func clyde_set(delta):
	while (!level1.game_over):
		Clyde.call_deferred("behaviour",delta)
		Clyde.call_deferred("update_ghost",delta)
		yield(get_tree(), "idle_frame")

func _on_Pacman_get_big_dot():
	Blinky.set_ia_state(Blinky.STATE_RETREATING)
	Pinky.set_ia_state(Pinky.STATE_RETREATING)
	Inky.set_ia_state(Inky.STATE_RETREATING)
	Clyde.set_ia_state(Clyde.STATE_RETREATING)
	
func _exit_tree():
	blinky_thread.wait_to_finish()
	pinky_thread.wait_to_finish()
	inky_thread.wait_to_finish()
	clyde_thread.wait_to_finish()
	pass
