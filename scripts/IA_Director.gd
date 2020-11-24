extends Node

export var warn_percent = 0.25

onready var Blinky = get_node("Blinky")
onready var Pinky = get_node("Pinky")
onready var Inky = get_node("Inky")
onready var Clyde = get_node("Clyde")

onready var pacman = get_parent().get_node("Pacman")
onready var tile_map = get_parent().get_node("Navigation2D/TileMap")
var pacman_power_up = false
var INIT_GHOSTS_EXECUTION_TIME

func _physics_process(delta):
	INIT_GHOSTS_EXECUTION_TIME = OS.get_ticks_usec()
	Blinky.behaviour(delta)
	Blinky.update_ghost(delta)
	Pinky.behaviour(delta)
	Pinky.update_ghost(delta)
	Inky.behaviour(delta)
	Inky.update_ghost(delta)
	Clyde.behaviour(delta)
	Clyde.update_ghost(delta)

func _on_Pacman_get_big_dot():
	Blinky.set_ia_state(Blinky.STATE_RETREATING)
	Pinky.set_ia_state(Pinky.STATE_RETREATING)
	Inky.set_ia_state(Inky.STATE_RETREATING)
	Clyde.set_ia_state(Clyde.STATE_RETREATING)
