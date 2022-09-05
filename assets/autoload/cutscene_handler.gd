extends Node

var is_paused = false

func toggle_pause():
	
	is_paused = Tools.toggle_true_false(is_paused, "cutscene_handeler.gd")
	

func _process(delta):
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	if DevConsole.is_open == false:
		get_tree().paused = is_paused
	
