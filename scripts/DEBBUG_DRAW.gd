extends Node2D

export var pinky_predict_color = Color(1,1,1,1)
var target_pos = Vector2()
onready var level1 = get_parent()
onready var director = get_parent().get_node("Director")
onready var pinky = get_parent().get_node("Director/Pinky")
onready var pacman = get_parent().get_node("Pacman")
var arquivo_global_exec = File.new()
var arquivo_local_exec = File.new()
var global_exec = 0
var local_exec = 0
var show_freq_timer = 0

func _ready():
	arquivo_global_exec.open("global_exec.txt", File.WRITE)
	arquivo_local_exec.open("local_exec.txt", File.WRITE)
	arquivo_global_exec.store_string("Time to process (microseconds)\n")
	arquivo_local_exec.store_string("Time to process (microseconds)\n")

func _draw():
	#draw_circle(self.target_pos, 4, pinky_predict_color)
	pass

func _physics_process(delta):
	if (level1.game_over):
		return
	var diff_local = OS.get_ticks_usec() - director.INIT_GHOSTS_EXECUTION_TIME
	var diff_global = OS.get_ticks_usec() - level1.INIT_EXECUTION_TIME
	arquivo_global_exec.store_string("%d\n"%[diff_global])
	arquivo_local_exec.store_string("%d\n"%[diff_local])
	show_freq_timer-=delta
	if (show_freq_timer <= 0):
		show_freq_timer = 1.5
		global_exec = diff_global
		local_exec = diff_local
	level1.label_right.text = "SCRIPTS EXEC MAX TIME: %d\nIA EXEC MAX TIME: %d\n"%[global_exec, local_exec]
	pass

func _on_Pinky_on_target_pos_signal(target_pos):
	self.target_pos = target_pos
	update()

func _exit_tree():
	arquivo_global_exec.close()
	arquivo_local_exec.close()
