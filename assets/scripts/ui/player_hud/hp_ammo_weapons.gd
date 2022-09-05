extends Node2D

var reset = false
var tweened = false
var weapon_offset = Vector2(7, 10)

signal got_weapons()

func _ready():
	
	PlayerProgress.connect("shift_weapons_left", self, "shift_left")
	PlayerProgress.connect("shift_weapons_right", self, "shift_right")
	PlayerProgress.connect("update_weapons_listing", self, "reset_icons")
	reset_icons()
	

func _process(delta):
	
	$player_pos.text = str("Player_pos:", PlayerProgress.player_pos)
	$fps.text = str("FPS:", Engine.get_frames_per_second())
	$movement.text = str("Movement:", PlayerProgress.player_movement)
	
	if PlayerProgress.current_player_gun == 0:
		$ammo_bar.max_value = 1
		$ammo_bar.value = 0
		$ammo_label.text = "---"
	elif PlayerProgress.current_player_gun == 1:
		$ammo_bar.max_value = 1
		$ammo_bar.value = 1
		$ammo_label.text = "---"
	elif PlayerProgress.current_player_gun == 2:
		$ammo_bar.max_value = PlayerProgress.player_stuff.repeater_maximum_ammo
		$ammo_bar.value = PlayerProgress.repeater_current_ammo
		$ammo_label.text = str(PlayerProgress.repeater_current_ammo)
	elif PlayerProgress.current_player_gun == 3:
		$ammo_bar.max_value = 1
		if PlayerProgress.wrench_has_spawned:
			$ammo_bar.value = 0
			$ammo_label.text = "0"
		elif PlayerProgress.player_stuff.blade_level == 3:
			$ammo_bar.value = 3
			$ammo_label.text = "3"
		else:
			$ammo_bar.value = 1
			$ammo_label.text = "1"
	else:
		$ammo_bar.max_value = PlayerProgress.player_stuff.shotgun_maximum_ammo
		$ammo_bar.value = PlayerProgress.shotgun_current_ammo
		$ammo_label.text = str(PlayerProgress.shotgun_current_ammo)
	
	$health_bar.max_value = PlayerProgress.player_max_hp
	$health_bar.value = PlayerProgress.current_player_hp
	$health_label.text = str(PlayerProgress.current_player_hp)
	
	if PlayerProgress.jetpack_fuel != 0 and PlayerProgress.jetpack_fuel != 50:
		reset = false
		tweened = false
		$booster_bar.value = PlayerProgress.jetpack_fuel
	elif PlayerProgress.jetpack_fuel == 0 and tweened == false:
		tweened = true
		$booster_bar.texture_progress = preload("res://assets/textures/ui/player_hud/booster_bar_red.png")
		$booster_base.frame = 2
		$booster_bar/t.interpolate_property($booster_bar, "value", 0, 50, 0.50, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$booster_bar/t.start()
	elif PlayerProgress.jetpack_fuel == 50 and reset == false:
		$booster_bar/t.stop_all()
		$booster_bar/t.remove_all()
		$booster_bar.value = 50
		$booster_base.frame = 1
		$booster_bar.texture_progress = preload("res://assets/textures/ui/player_hud/booster_bar_green.png")
		reset = true

func reset_icons():
	if $weapons.get_child_count() > 0:
		for i in $weapons.get_child_count():
			var list = $weapons.get_children()
			list[0].free()
	var stuff = []
	stuff = get_list_of_weapons()
	for i in stuff.size():
		var icon = preload("res://assets/scenes/ui/hud/weapon_icon.tscn").instance()
		icon.icon = stuff[i]
		$weapons.add_child(icon)

func get_list_of_weapons():
	var listing = []
	if PlayerProgress.player_stuff.pistol_level != 0:
		listing.append(1)
	if PlayerProgress.player_stuff.repeater_level != 0:
		listing.append(2)
	if PlayerProgress.player_stuff.blade_level != 0:
		listing.append(3)
	if PlayerProgress.player_stuff.shotgun_level != 0:
		listing.append(4)
	if PlayerProgress.player_stuff.thunder_level != 0:
		listing.append(5)
	for i in PlayerProgress.current_player_gun - 1:
		var prev = listing.front()
		listing.pop_front()
		listing.append(prev)
	emit_signal("got_weapons")
	return listing

func shift_left():
	reset_icons()
	$wt.stop_all()
	$wt.remove_all()
	$wt.interpolate_property($weapons, "rect_position", weapon_offset + Vector2(10, 0), weapon_offset, 0.15, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$wt.start()

func shift_right():
	reset_icons()
	$wt.stop_all()
	$wt.remove_all()
	$wt.interpolate_property($weapons, "rect_position", weapon_offset + Vector2(-10, 0), weapon_offset, 0.15, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$wt.start()
