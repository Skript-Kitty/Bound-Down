extends RigidBody2D

var bullet_type
var damage = 1
onready var art = get_node("texture")
onready var anim = get_node("anim")
var dir

func _ready():
	
	dir = rotation_degrees
	
	if bullet_type == "pistol":
		
		damage = PlayerProgress.player_stuff.pistol_level * 2
		
		$timmy.wait_time = 0.5
		$timmy.start()
		
		$collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider.tres")
		$collider.position = Vector2(2.5, 0.5)
		$area/collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider.tres")
		$area/collider.position = Vector2(2.5, 0.5)
		
		art.position = Vector2(3, 1)
		art.texture = preload("res://assets/textures/gameplay/player/bullets/pistol_bullet.png")
		art.hframes = 3
		
		art.frame = PlayerProgress.player_stuff.pistol_level - 1
		
		anim.play("RESET")
		
	elif bullet_type == "repeater":
		
		damage = PlayerProgress.player_stuff.repeater_level
		
		$timmy.wait_time = 1
		$timmy.start()
		
		$collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider.tres")
		$collider.position = Vector2(2.5, 0.5)
		$area/collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider.tres")
		$area/collider.position = Vector2(2.5, 0.5)
		
		art.position = Vector2(3, 1)
		art.texture = preload("res://assets/textures/gameplay/player/bullets/machine_gun_bullet.png")
		art.hframes = 3
		
		art.frame = PlayerProgress.player_stuff.repeater_level - 1
		
		anim.play("RESET")
		
	elif bullet_type == "thunder":
		var minimum_percentage = ceil(PlayerProgress.player_max_hp / 4)
		
		if PlayerProgress.current_player_hp <= minimum_percentage:
			damage = 15
			
			$audio.stream = preload("res://assets/sound/sfx/player/thundershot.wav")
			$audio.play()
			
			$timmy.wait_time = 0.5
			$timmy.start()
			
			$collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider.tres")
			$collider.position = Vector2(2.5, 0.5)
			$area/collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider.tres")
			$area/collider.position = Vector2(2.5, 0.5)
			
			art.position = Vector2(-9, 1)
			art.texture = preload("res://assets/textures/gameplay/player/bullets/thunder.png")
			art.hframes = 5
			
			art.frame = 0
			
			$t.interpolate_property(art, "frame", 1, 4, 0.2, Tween.TRANS_LINEAR)
			$t.interpolate_property(art, "scale", Vector2.ZERO, Vector2.ONE, 0.2, Tween.TRANS_LINEAR)
			$t.start()
			
			anim.play("RESET")
			
		else:
			damage = 1
			$timmy.wait_time = 0.25
			$timmy.start()
			
			$collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider.tres")
			$collider.position = Vector2(2.5, 0.5)
			$area/collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider.tres")
			$area/collider.position = Vector2(2.5, 0.5)
			
			art.position = Vector2(3, 1)
			art.texture = preload("res://assets/textures/gameplay/player/bullets/machine_gun_bullet.png")
			art.hframes = 3
			
			art.frame = 0
			
			anim.play("RESET")
		
	
	elif bullet_type == "blade":
		
		if PlayerProgress.player_stuff.blade_level == 1:
			damage = 5
		else:
			damage = 10
		
		$timmy.wait_time = 0.25
		$timmy.start()
		
		$collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider_big.tres")
		$collider.position = Vector2.ZERO
		$area/collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider_big.tres")
		$area/collider.position = Vector2.ZERO
		
		art.position = Vector2.ZERO
		art.texture = preload("res://assets/textures/gameplay/player/bullets/wrench.png")
		art.hframes = 2
		
		if PlayerProgress.player_stuff.blade_level == 1:
			art.frame = 0
		else:
			art.frame = 1
		
		if rotation_degrees == 0 or rotation_degrees == 270:
			anim.play("spin")
		else:
			anim.play_backwards("spin")
	
	elif bullet_type == "blade_clone":
		
		damage = 5
		
		$timmy.wait_time = 0.25
		$timmy.start()
		
		$collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider_big.tres")
		$collider.position = Vector2.ZERO
		$area/collider.shape = preload("res://assets/scenes/gameplay/player/bullet_square_collider_big.tres")
		$area/collider.position = Vector2.ZERO
		
		art.position = Vector2.ZERO
		art.texture = preload("res://assets/textures/gameplay/player/bullets/wrench.png")
		art.hframes = 2
		
		art.frame = 0
		
		if rotation_degrees == 0 or rotation_degrees == 270:
			anim.play("spin")
		else:
			anim.play_backwards("spin")
		
	else:
		
		if PlayerProgress.player_stuff.blade_level == 1:
			damage = 1
		else:
			damage = 3
		
		$area.queue_free()
		$area/collider.queue_free()
		
		$timmy.wait_time = 3.0
		$timmy.start()
		
		$collider.shape = preload("res://assets/scenes/gameplay/player/bullet_round_collider.tres")
		$collider.position = Vector2.ZERO
		$area/collider.shape = preload("res://assets/scenes/gameplay/player/bullet_round_collider.tres")
		$area/collider.position = Vector2.ZERO
		
		physics_material_override = preload("res://assets/scenes/gameplay/player/bullet_bubble.tres")
		
		rotation_degrees = 0
		art.position = Vector2.ZERO
		art.texture = preload("res://assets/textures/gameplay/player/bullets/bubble_bullet.png")
		art.hframes = 2
		
		if PlayerProgress.player_stuff.shotgun_level == 1:
			art.frame = 0
		else:
			art.frame = 1
		
		anim.play("come")
	

func _process(delta):
	
	if bullet_type == "shotgun":
		angular_velocity = 0
		rotation_degrees = 0
	else:
		angular_velocity = 0
	
	#angular_velocity = 0


func _on_timmy_timeout():
	
	$collider.set_deferred("disabled", true)
	
	if bullet_type == "shotgun":
		
		if PlayerProgress.player_stuff.shotgun_level == 1:
			linear_velocity = Vector2.ZERO
			art.texture = preload("res://assets/textures/gameplay/player/bubble_pop.png")
			art.hframes = 4
			art.frame = 0
			$t.interpolate_property(art, "frame", 0, 3, 0.25, Tween.TRANS_LINEAR)
			$t.start()
			yield($t, "tween_all_completed")
			queue_free()
		else:
			linear_velocity = Vector2.ZERO
			art.texture = preload("res://assets/textures/gameplay/player/bubble_pop_two.png")
			art.hframes = 4
			art.frame = 0
			$t.interpolate_property(art, "frame", 0, 3, 0.25, Tween.TRANS_LINEAR)
			$t.start()
			yield($t, "tween_all_completed")
			queue_free()
	elif bullet_type == "blade":
		
		$anim.stop()
		$anim.play("RESET")
		PlayerProgress.wrench_has_spawned = false
		linear_velocity = Vector2.ZERO
		reset_dir()
		art.texture = preload("res://assets/textures/gameplay/player/blade_delete.png")
		art.hframes = 8
		art.frame = 0
		$t.interpolate_property(art, "frame", 0, 7, 0.4, Tween.TRANS_LINEAR)
		$t.start()
		yield($t, "tween_all_completed")
		queue_free()
	elif bullet_type == "thunder":
		
		$anim.stop()
		$anim.play("RESET")
		art.position = Vector2.ZERO
		PlayerProgress.wrench_has_spawned = false
		linear_velocity = Vector2.ZERO
		reset_dir()
		art.texture = preload("res://assets/textures/gameplay/player/blade_delete.png")
		art.hframes = 8
		art.frame = 0
		$t.interpolate_property(art, "frame", 0, 7, 0.4, Tween.TRANS_LINEAR)
		$t.start()
		yield($t, "tween_all_completed")
		queue_free()
	elif bullet_type == "blade_clone":
		
		$anim.stop()
		$anim.play("RESET")
		linear_velocity = Vector2.ZERO
		reset_dir()
		art.texture = preload("res://assets/textures/gameplay/player/blade_delete.png")
		art.hframes = 8
		art.frame = 0
		$t.interpolate_property(art, "frame", 0, 7, 0.4, Tween.TRANS_LINEAR)
		$t.start()
		yield($t, "tween_all_completed")
		queue_free()
	else:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		reset_dir()
		art.texture = preload("res://assets/textures/gameplay/player/bullet_dissapear.png")
		art.hframes = 8
		art.frame = 0
		$t.interpolate_property(art, "frame", 0, 7, 0.35, Tween.TRANS_LINEAR)
		rotation_degrees = 0
		$t.start()
		yield($t, "tween_all_completed")
		queue_free()


func _on_backup_timer_timeout():
	queue_free()


func _on_area_body_entered(body):
	if body.is_in_group("wall") and not bullet_type == "shotgun":
		$timmy.stop()
		$timmy.emit_signal("timeout")

func reset_dir():
	$area.queue_free()
	$area/collider.queue_free()
	rotation_degrees = 0
