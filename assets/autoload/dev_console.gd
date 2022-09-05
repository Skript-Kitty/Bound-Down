extends CanvasLayer

var is_open = false
var request_more_info = false
var returner # Yes
var pointer = 0
var pointer_closed = true

signal enter_pressed()
signal completed_request()

var valid_commands = [
	
	"info",
	"clear",
	"help",
	"quit",
	"render_2d",
	"render_viewport",
	"clear_input_history",
	"input_history",
	"ara_ara",
	"ammo_increment",
	"ammo_decrement",
	"god",
	"fullscreen",
	"window",
	
	"set_player_hp",
	"set_player_max_hp",
	"set_player_ammo_repeater",
	"set_player_ammo_shotgun",
	"set_player_max_ammo_repeater",
	"set_player_max_ammo_shotgun",
	
]

var command_log = [
	
	
	
]

func _ready():
	visible = false


func print_to_console(text):
	$console_text.append_bbcode(text)


func _process(delta):
	
	if Input.is_action_just_pressed("dev_console"):
		
		is_open = Tools.toggle_true_false(is_open, "dev_console.gd")
		
		if is_open != null:
			if is_open == true:
				visible = true
				get_tree().paused = true
				$console_text.append_bbcode(str("[gray]Press ` again to close.", "[/gray]\n"))
				pointer = 0
			else:
				visible = false
				$focus_steal.grab_focus()
				$human_input.clear()
				if CutsceneHandler.is_paused == false:
					get_tree().paused = false
	
	if Input.is_action_just_pressed("dev_console_up") and command_log.size() > 0:
		if pointer_closed == true:
			pointer_closed = false
			$human_input.text = command_log[pointer]
		else:
			pointer = pointer + 1
			pointer = clamp(pointer, 0, command_log.size() - 1)
			$human_input.text = command_log[pointer]
	elif Input.is_action_just_pressed("dev_console_down") and command_log.size() > 0:
		if pointer_closed == true or pointer == 0:
			pointer_closed = false
			$human_input.text = command_log[0]
		else:
			pointer = pointer - 1
			$human_input.text = command_log[pointer]


func _input(event):
	
	if Input.is_action_just_pressed("dev_console_go") and not request_more_info:
		
		var text = $human_input.text
		$console_text.append_bbcode(str("> [gray]", text, "[/gray]\n"))
		command_log.insert(0, text)
		$human_input.clear()
		
		if valid_commands.has(text):
			
			self.call_deferred(text)
			
		else:
			
			$console_text.append_bbcode(str("[red]Invalid Command. Please type 'help' for a list of commands! Please also use only lowercase![/red]", "\n"))
			
	elif Input.is_action_just_pressed("dev_console_go"):
		emit_signal("enter_pressed")




func help():
	$console_text.append_bbcode(str(valid_commands, "\n"))

func clear():
	$console_text.clear()

func quit():
	get_tree().quit()

func info():
	$console_text.append_bbcode(str("[green][center]- BOUND DOWN -\nCreated by: Skript-Kitty\nMade for the Metroidvania Month 17 jam[/center][/green]", "\n"))

func ara_ara():
	$console_text.append_bbcode(str("Frickin' weeb.\n"))

func clear_input_history():
	command_log.clear()
	$console_text.append_bbcode(str("[green]Input history cleared successfully![/green]", "\n"))

func render_2d():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, Vector2(300, 200), 1)
	$console_text.append_bbcode(str("[green]Render mode changed successfully![/green]", "\n"))

func input_history():
	$console_text.append_bbcode(str(command_log, "\n"))
	$console_text.append_bbcode(str("[green]Input history displayed.[/green]", "\n"))

func render_viewport():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(300, 200), 1)
	$console_text.append_bbcode(str("[green]Render mode changed successfully![/green]", "\n"))

func set_player_hp():
	var numero = 0
	request_int()
	yield(self, "completed_request")
	numero = returner
	if numero == null:
		$console_text.append_bbcode(str("Session terminated.", "\n"))
	else:
		if numero > PlayerProgress.player_max_hp:
			$console_text.append_bbcode(str("[yellow]Input value is greater than player max hp, please adjust that first.\nResult changed to ", str(clamp(numero, 1, PlayerProgress.player_max_hp)), " instead[/yellow]\n"))
		elif numero < 1:
			$console_text.append_bbcode(str("[yellow]Input value is less than 1. If you wish to kill yourself please input 'suicide'.\nResult changed to ", str(clamp(numero, 1, PlayerProgress.player_max_hp)), " instead[/yellow]\n"))
		PlayerProgress.current_player_hp = clamp(numero, 1, PlayerProgress.player_max_hp)
		$console_text.append_bbcode(str("[green]Player health changed successfully![/green]", "\n"))

func set_player_max_hp():
	var numero = 0
	request_int()
	yield(self, "completed_request")
	numero = returner
	if numero == null:
		$console_text.append_bbcode(str("Session terminated.", "\n"))
	else:
		if numero > 2147483647:
			$console_text.append_bbcode(str("[yellow]Input value is greater than the arbitrary number (2147483647) chosen by the developer to make the 'clamp' function work. Why you need hp this high makes no sense.\nResult changed to 2147483647 instead[/yellow]\n"))
		elif numero < 1:
			$console_text.append_bbcode(str("[yellow]Input value is less than 1. If you wish to kill yourself please input 'suicide'.\nResult changed to 1 instead[/yellow]\n"))
		if numero < PlayerProgress.current_player_hp:
			$console_text.append_bbcode(str("[yellow]Input value is less than the player hp. \nPlayer hp changed to new max health.[/yellow]\n"))
			PlayerProgress.current_player_hp = clamp(numero, 1, 2147483647)
			$console_text.append_bbcode(str("[green]Player health changed successfully![/green]", "\n"))
		PlayerProgress.player_max_hp = clamp(numero, 1, 2147483647)
		$console_text.append_bbcode(str("[green]Player max health changed successfully![/green]", "\n"))

func set_player_ammo_repeater():
	var numero = 0
	request_int()
	yield(self, "completed_request")
	numero = returner
	if numero == null:
		$console_text.append_bbcode(str("Session terminated.", "\n"))
	else:
		if numero > PlayerProgress.player_stuff.repeater_maximum_ammo:
			$console_text.append_bbcode(str("[yellow]Input value is greater than repeater max ammo, please adjust that first.\nResult changed to ", str(clamp(numero, 0, PlayerProgress.player_stuff.repeater_maximum_ammo)), " instead[/yellow]\n"))
		elif numero < 0:
			$console_text.append_bbcode(str("[yellow]Input value is less than 0.\nResult changed to ", str(clamp(numero, 0, PlayerProgress.player_stuff.repeater_maximum_ammo)), " instead[/yellow]\n"))
		PlayerProgress.repeater_current_ammo = clamp(numero, 0, PlayerProgress.player_stuff.repeater_maximum_ammo)
		$console_text.append_bbcode(str("[green]Repeater ammo changed successfully![/green]", "\n"))

func set_player_max_ammo_repeater():
	var numero = 0
	request_int()
	yield(self, "completed_request")
	numero = returner
	if numero == null:
		$console_text.append_bbcode(str("Session terminated.", "\n"))
	else:
		if numero > 2147483647:
			$console_text.append_bbcode(str("[yellow]Input value is greater than the arbitrary number (2147483647) chosen by the developer to make the 'clamp' function work. Why you need this much ammo makes no sense.\nResult changed to 2147483647 instead[/yellow]\n"))
		elif numero < 1:
			$console_text.append_bbcode(str("[yellow]Input value is less than 0.\nResult changed to 1 instead[/yellow]\n"))
		if numero < PlayerProgress.repeater_current_ammo:
			$console_text.append_bbcode(str("[yellow]Input value is less than the current repeater ammo. \nRepeater ammo changed to new max ammo.[/yellow]\n"))
			PlayerProgress.repeater_current_ammo = clamp(numero, 0, 2147483647)
			$console_text.append_bbcode(str("[green]Repeater ammo changed successfully![/green]", "\n"))
		PlayerProgress.player_stuff.repeater_maximum_ammo = clamp(numero, 0, 2147483647)
		$console_text.append_bbcode(str("[green]Maximum repeater ammo changed successfully![/green]", "\n"))

func set_player_ammo_shotgun():
	var numero = 0
	request_int()
	yield(self, "completed_request")
	numero = returner
	if numero == null:
		$console_text.append_bbcode(str("Session terminated.", "\n"))
	else:
		if numero > PlayerProgress.player_stuff.shotgun_maximum_ammo:
			$console_text.append_bbcode(str("[yellow]Input value is greater than repeater max ammo, please adjust that first.\nResult changed to ", str(clamp(numero, 0, PlayerProgress.player_stuff.shotgun_maximum_ammo)), " instead[/yellow]\n"))
		elif numero < 0:
			$console_text.append_bbcode(str("[yellow]Input value is less than 0.\nResult changed to ", str(clamp(numero, 0, PlayerProgress.player_stuff.shotgun_maximum_ammo)), " instead[/yellow]\n"))
		PlayerProgress.shotgun_current_ammo = clamp(numero, 0, PlayerProgress.player_stuff.shotgun_maximum_ammo)
		$console_text.append_bbcode(str("[green]Shotgun ammo changed successfully![/green]", "\n"))

func set_player_max_ammo_shotgun():
	var numero = 0
	request_int()
	yield(self, "completed_request")
	numero = returner
	if numero == null:
		$console_text.append_bbcode(str("Session terminated.", "\n"))
	else:
		if numero > 2147483647:
			$console_text.append_bbcode(str("[yellow]Input value is greater than the arbitrary number (2147483647) chosen by the developer to make the 'clamp' function work. Why you need this much ammo makes no sense.\nResult changed to 2147483647 instead[/yellow]\n"))
		elif numero < 1:
			$console_text.append_bbcode(str("[yellow]Input value is less than 0.\nResult changed to 1 instead[/yellow]\n"))
		if numero < PlayerProgress.shotgun_current_ammo:
			$console_text.append_bbcode(str("[yellow]Input value is less than the current repeater ammo. \nRepeater ammo changed to new max ammo.[/yellow]\n"))
			PlayerProgress.shotgun_current_ammo = clamp(numero, 0, 2147483647)
			$console_text.append_bbcode(str("[green]Repeater ammo changed successfully![/green]", "\n"))
		PlayerProgress.player_stuff.shotgun_maximum_ammo = clamp(numero, 0, 2147483647)
		$console_text.append_bbcode(str("[green]Maximum shotgun ammo changed successfully![/green]", "\n"))

func ammo_increment():
	PlayerProgress.repeater_current_ammo = PlayerProgress.repeater_current_ammo + 1
	PlayerProgress.shotgun_current_ammo = PlayerProgress.shotgun_current_ammo + 1
	$console_text.append_bbcode(str("[green]Incremented all ammunition by one.[/green]", "\n"))

func ammo_decrement():
	PlayerProgress.repeater_current_ammo = PlayerProgress.repeater_current_ammo - 1
	PlayerProgress.shotgun_current_ammo = PlayerProgress.shotgun_current_ammo - 1
	$console_text.append_bbcode(str("[green]Decremented all ammunition by one.[/green]", "\n"))

func fullscreen():
	OS.window_borderless = true
	OS.window_fullscreen = true
	OS.window_resizable = false
	$console_text.append_bbcode(str("[green]Changed view to fullscreen.[/green]", "\n"))

func window():
	var gameres = OS.get_screen_size()
	OS.window_borderless = false
	OS.window_fullscreen = false
	OS.window_resizable = true
	OS.window_size = Vector2(600, 400)
	OS.window_position = (gameres / 2) - (Vector2(600, 400) / 2)
	$console_text.append_bbcode(str("[green]Changed view to windowed.[/green]", "\n"))

func god():
	PlayerProgress.player_max_hp = 2147483647
	PlayerProgress.current_player_hp = 2147483647
	PlayerProgress.player_stuff.repeater_maximum_ammo = 2147483647
	PlayerProgress.repeater_current_ammo = 2147483647
	PlayerProgress.player_stuff.shotgun_maximum_ammo = 2147483647
	PlayerProgress.shotgun_current_ammo = 2147483647
	$console_text.append_bbcode(str("[green]Player stats set to an insane high.[/green]", "\n"))




func request_int():
	var incomplete = true
	var final_value
	while incomplete:
		
		request_more_info = true
		$console_text.append_bbcode(str("Please input your desired integer | Input 'stop' to close", "\n"))
		
		yield(self, "enter_pressed")
		var text = $human_input.text
		$console_text.append_bbcode(str("> [gray]", text, "[/gray]\n"))
		command_log.append(text)
		$human_input.clear()
		
		if text == "stop":
			incomplete = false
			final_value = null
		elif not text.is_valid_integer():
			if text.is_valid_float():
				$console_text.append_bbcode(str("[red]Number imported was a float, not an integer. Please import an integer instead.[/red]", "\n"))
			else:
				$console_text.append_bbcode(str("[red]Text imported had a mixture of numbers and letters, or had no numbers. Please import a valid integer instead.[/red]", "\n"))
		else:
			incomplete = false
			final_value = int(text)
	request_more_info = false
	returner = final_value
	emit_signal("completed_request")


func request_float():
	var incomplete = true
	var final_value
	while incomplete:
		
		request_more_info = true
		$console_text.append_bbcode(str("Please input your desired integer | Input 'stop' to close", "\n"))
		
		yield(self, "enter_pressed")
		var text = $human_input.text
		$console_text.append_bbcode(str("> [gray]", text, "[/gray]\n"))
		command_log.append(text)
		$human_input.clear()
		
		if text == "stop":
			incomplete = false
			final_value = null
		elif not text.is_valid_float():
			$console_text.append_bbcode(str("[red]Text imported had a mixture of numbers and letters, or had no numbers. Please import a valid integer instead.[/red]", "\n"))
		else:
			incomplete = false
			final_value = int(text)
		
	request_more_info = false
	print(final_value, " Final value before return")
	returner = final_value
	emit_signal("completed_request")


func _on_human_input_text_changed(new_text):
	pointer_closed = true
	pointer = 0
