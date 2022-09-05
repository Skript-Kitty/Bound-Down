extends Node

signal updated_repeater_ammo()
signal updated_shotgun_ammo()
signal update_weapons_listing()
signal shift_weapons_left()
signal shift_weapons_right()

var player_stuff = {
	
	"maximum_life":3,
	
	"has_jetpack":true,
	"has_double_jump":true,
	
	"pistol_level":1,
	
	"repeater_level":1,
	"repeater_maximum_ammo":350,
	
	"shotgun_level":1,
	"shotgun_maximum_ammo":75,
	
	"blade_level":1,
	
	"thunder_level":1,
	
}

var current_player_gun = 1

var current_player_hp = 1
var player_max_hp = 50

var wrench_has_spawned = false

var repeater_current_ammo = 1 setget repeater_ammo_changed
var shotgun_current_ammo = 1 setget shotgun_ammo_changed

var jetpack_fuel = 50

var player_pos = Vector2.ZERO
var player_movement = Vector2.ZERO

func _process(delta):
	repeater_current_ammo = clamp(repeater_current_ammo, 0, player_stuff.repeater_maximum_ammo)
	shotgun_current_ammo = clamp(shotgun_current_ammo, 0, player_stuff.shotgun_maximum_ammo)

func swap_weapon_left():
	
	current_player_gun = current_player_gun - 1
	
	if current_player_gun == 0 or current_player_gun == -1:
		current_player_gun = 5
	
	var gun_in_question = convert_current_gun_to_str()
	var passer = false
	
	if gun_in_question == null:
		DevConsole.print_to_console(str("[red]Error Tried to switch to and invalid weapon! Swap failed.\nCurrent player gun variable is: ", str(current_player_gun), "[/red]\n"))
	else:
		
		if player_stuff.get(str(gun_in_question, "_level")) == 0:
			for i in 4:
				
				if passer == false:
					
					current_player_gun = current_player_gun - 1
					
					if current_player_gun == 0 or current_player_gun == -1:
						current_player_gun = 5
					
					gun_in_question = convert_current_gun_to_str()
					
					if gun_in_question == null:
						DevConsole.print_to_console(str("[red]Error Tried to switch to and invalid weapon! Swap failed.\nCurrent player gun variable is: ", str(current_player_gun), "[/red]\n"))
					else:
						if player_stuff.get(str(gun_in_question, "_level")) == 0:
							
							pass
							
						else:
							
							passer = true
							pass
		emit_signal("shift_weapons_right")


func swap_weapon_right():
	
	current_player_gun = current_player_gun + 1
	
	if current_player_gun == 6 or current_player_gun == 7:
		current_player_gun = 1
	
	var gun_in_question = convert_current_gun_to_str()
	var passer = false
	
	if gun_in_question == null:
		DevConsole.print_to_console(str("[red]Error Tried to switch to and invalid weapon! Swap failed.\nCurrent player gun variable is: ", str(current_player_gun), "[/red]\n"))
	else:
		
		if player_stuff.get(str(gun_in_question, "_level")) == 0:
			for i in 4:
				
				if passer == false:
					
					current_player_gun = current_player_gun + 1
					
					if current_player_gun == 7 or current_player_gun == 6:
						current_player_gun = 1
					
					gun_in_question = convert_current_gun_to_str()
					
					if gun_in_question == null:
						DevConsole.print_to_console(str("[red]Error Tried to switch to and invalid weapon! Swap failed.\nCurrent player gun variable is: ", str(current_player_gun), "[/red]\n"))
					else:
						if player_stuff.get(str(gun_in_question, "_level")) == 0:
							
							pass
							
						else:
							
							passer = true
							pass
		emit_signal("shift_weapons_left")



func convert_current_gun_to_str():
	
	if current_player_gun == 1:
		return "pistol"
	elif current_player_gun == 2:
		return "repeater"
	elif current_player_gun == 3:
		return "blade"
	elif current_player_gun == 4:
		return "shotgun"
	elif current_player_gun == 5:
		return "thunder"
	else:
		return null
	

func repeater_ammo_changed(sept):
	repeater_current_ammo = sept
	emit_signal("updated_repeater_ammo")

func shotgun_ammo_changed(sept):
	shotgun_current_ammo = sept
	emit_signal("updated_shotgun_ammo")
