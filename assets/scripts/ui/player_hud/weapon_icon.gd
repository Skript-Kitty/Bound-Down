extends Control

var icon = 2

func _ready():
	
	PlayerProgress.connect("updated_repeater_ammo", self, "repeater_ammo")
	PlayerProgress.connect("updated_shotgun_ammo", self, "shotgun_ammo")
	
	if icon == 1:
		$art.frame_coords = Vector2(1, PlayerProgress.player_stuff.pistol_level - 1)
	elif icon == 2:
		if PlayerProgress.repeater_current_ammo != 0:
			$art.frame_coords = Vector2(2, PlayerProgress.player_stuff.repeater_level - 1)
		else:
			$art.frame_coords = Vector2(6, PlayerProgress.player_stuff.repeater_level - 1)
	elif icon == 3:
		$art.frame_coords = Vector2(3, PlayerProgress.player_stuff.blade_level - 1)
	elif icon == 4:
		if PlayerProgress.shotgun_current_ammo != 0:
			$art.frame_coords = Vector2(4, PlayerProgress.player_stuff.shotgun_level - 1)
		else:
			$art.frame_coords = Vector2(7, PlayerProgress.player_stuff.shotgun_level - 1)
	elif icon == 5:
		$art.frame_coords = Vector2(5, PlayerProgress.player_stuff.blade_level - 1)
	else:
		$art.frame = 0

func repeater_ammo():
	if PlayerProgress.repeater_current_ammo != 0 and icon == 2:
		print('yeas')
		print(PlayerProgress.repeater_current_ammo)
		$art.frame_coords = Vector2(2, PlayerProgress.player_stuff.repeater_level - 1)
	elif icon == 2:
		print('yeas')
		$art.frame_coords = Vector2(6, PlayerProgress.player_stuff.repeater_level - 1)

func shotgun_ammo():
	if PlayerProgress.shotgun_current_ammo != 0 and icon == 4:
		$art.frame_coords = Vector2(4, PlayerProgress.player_stuff.shotgun_level - 1)
	elif icon == 4:
		$art.frame_coords = Vector2(7, PlayerProgress.player_stuff.shotgun_level - 1)
