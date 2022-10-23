extends KinematicBody2D

var ACCELLERATION = 7.5
var MAX_SPEED = 75
var DECELLERATION = 10
var JUMP = -150
var GRAVITY = 4
var TERMINAL_VELOCITY = 150
var SNAP_LENGTH = Vector2(0, 6)

var underwater_multiplier = 1

var movement = Vector2.ZERO
var snap = 0

var anim_movement = Vector2.ZERO
var anim_weapon_offset = 2
export var anim_walk_frame = 0

var JETPACK_FUEL_MAX = 50
var jetpack_fuel = 50

var flag_animating = true
var flag_has_double_jumped = false
var flag_has_started_jetpacking = false
var flag_facing_right = true
var flag_can_shoot_repeater = true
var is_on_the_floor = false
var was_on_the_floor = false
var coyote_time = false


func _ready():
	
	var has_proper_camera = false
	for i in get_child_count():
		if get_children()[i].name == "camera":
			has_proper_camera = true
	if not has_proper_camera:
		print("uh_oh_player_does_not_have_a_camera!!!!")
		ErrorHandler.throw_error_to_console(str("[red]Err player does not have proper camera.\nFrom ", "player.gd[/red]"))
		$cam.current = true
	
	if PlayerProgress.player_stuff.has_double_jump or PlayerProgress.player_stuff.has_jetpack:
		
		$player_sprite/jetpack.visible = true
		$player_sprite/jetpack/particles.emitting = false
		
	else:
		
		$player_sprite/jetpack.visible = false
		$player_sprite/jetpack/particles.emitting = false
		
	


func _physics_process(delta):
	
	var floorcast_floor = Vector2(0, 0) #the x is the left collider, the y is the right collider
	if $floorcast_l.is_colliding():
		if $floorcast_l.get_collider().is_in_group("floor"):
			floorcast_floor.x = 1 # Sets the x value to one, showing that the left collider is colliding with the floor.
		else:
			floorcast_floor.x = 0 # Sets the x value to zero, showing that the left collider is not colliding with the floor.
	elif $floorcast_r.is_colliding():
		if $floorcast_r.get_collider().is_in_group("floor"):
			floorcast_floor.y = 1 # Sets the y value to one, showing that the right collider is colliding with the floor.
		else:
			floorcast_floor.y = 0 # Sets the y value to zero, showing that the right collider is not colliding with the floor.
	
	if floorcast_floor.x == 1 or floorcast_floor.y == 1: # If either the x or y value is one, then the player is, in fact, touching the ground.
		is_on_the_floor = true
		snap = SNAP_LENGTH
	else:
		is_on_the_floor = false
		snap = Vector2.ZERO
	
	PlayerProgress.jetpack_fuel = jetpack_fuel
	
	if Input.is_action_just_pressed("shift_left") and PlayerProgress.current_player_gun != 0:
		PlayerProgress.swap_weapon_left()
	elif Input.is_action_just_pressed("shift_right") and PlayerProgress.current_player_gun != 0:
		PlayerProgress.swap_weapon_right()
	
	if Input.is_action_pressed("move_left"):
		
		anim_movement.x = -1
		movement.x = movement.x - ACCELLERATION * underwater_multiplier
		movement.x = clamp(movement.x, -MAX_SPEED * underwater_multiplier, 0)
		
	elif Input.is_action_pressed("move_right"):
		
		anim_movement.x = 1
		movement.x = movement.x + ACCELLERATION * underwater_multiplier
		movement.x = clamp(movement.x, 0, MAX_SPEED * underwater_multiplier)
		
	else:
		
		anim_movement.x = 0
		
		if movement.x == clamp(movement.x, -DECELLERATION * underwater_multiplier + 1, DECELLERATION * underwater_multiplier - 1):
			movement.x = 0
		elif movement.x >= DECELLERATION * underwater_multiplier:
			movement.x = movement.x - DECELLERATION * underwater_multiplier
		elif movement.x <= -DECELLERATION * underwater_multiplier:
			movement.x = movement.x + DECELLERATION * underwater_multiplier
	
	if not is_on_the_floor:
		
		if was_on_the_floor == true:
			was_on_the_floor = false
			coyote_time = true
			$coyote_time.start()
		
		movement.y = movement.y + GRAVITY * underwater_multiplier * (underwater_multiplier)
		
		movement.y = clamp(movement.y, -TERMINAL_VELOCITY * underwater_multiplier, TERMINAL_VELOCITY * underwater_multiplier)
		
		if Input.is_action_just_pressed("jump") and PlayerProgress.player_stuff.has_double_jump and not flag_has_double_jumped and not PlayerProgress.player_stuff.has_jetpack and not coyote_time:
			
			movement.y = JUMP * 0.8 * underwater_multiplier
			$player_sprite/jetpack/anim.play("shoot")
			flag_has_double_jumped = true
			
		elif Input.is_action_just_pressed("jump") and PlayerProgress.player_stuff.has_jetpack and jetpack_fuel > 0 and not coyote_time:
			$player_sprite/jetpack/particles.emitting = true
			flag_has_started_jetpacking = true
			
			movement.y = (JUMP * 0.3) * underwater_multiplier
			
			jetpack_fuel = jetpack_fuel - 1
			jetpack_fuel = clamp(jetpack_fuel, -JETPACK_FUEL_MAX, JETPACK_FUEL_MAX)
			
			if jetpack_fuel == 0:
				$sfx/jetpack_final.play()
				movement.y = movement.y + ((JUMP * 0.3) * underwater_multiplier)
				$player_sprite/jetpack/particles.emitting = false
				$player_sprite/jetpack/puff.emitting = true
			else:
				$sfx/jetpack.play()
			
		elif Input.is_action_pressed("jump") and PlayerProgress.player_stuff.has_jetpack and jetpack_fuel > 0 and flag_has_started_jetpacking and not coyote_time:
			$player_sprite/jetpack/particles.emitting = true
			movement.y = (JUMP * 0.6) * underwater_multiplier
			
			jetpack_fuel = jetpack_fuel - 1
			jetpack_fuel = clamp(jetpack_fuel, -JETPACK_FUEL_MAX, JETPACK_FUEL_MAX)
			
			if jetpack_fuel == 0:
				movement.y =  movement.y + ((JUMP * 0.3) * underwater_multiplier)
				$sfx/jetpack_final.play()
				$player_sprite/jetpack/particles.emitting = false
				$player_sprite/jetpack/puff.emitting = true
			else:
				$sfx/jetpack.play()
			
		elif not jetpack_fuel > 0:
			$player_sprite/jetpack/particles.emitting = false
			
	if is_on_the_floor or coyote_time:
		
		if Input.is_action_just_pressed("jump"):
			
			was_on_the_floor = false
			snap = Vector2.ZERO
			movement.y = JUMP
			$sfx/jump.play()
			if coyote_time:
				coyote_time = false
			
		elif not coyote_time:
			was_on_the_floor = true
			jetpack_fuel = JETPACK_FUEL_MAX
			flag_has_started_jetpacking = false
			flag_has_double_jumped = false
			movement.y = 0.01
			 
	
	if is_on_ceiling():
		movement.y = GRAVITY * underwater_multiplier
	
	if Input.is_action_just_released("jump") and movement.y < 0:
		movement.y = movement.y * 0.15
	if Input.is_action_just_released("jump") and flag_has_started_jetpacking:
		$player_sprite/jetpack/particles.emitting = false
	
	animate()
	
	if Input.is_action_pressed("shoot") and PlayerProgress.current_player_gun == 2 and flag_can_shoot_repeater and PlayerProgress.repeater_current_ammo != 0: #Shooting code for the repeater
		
		PlayerProgress.repeater_current_ammo = PlayerProgress.repeater_current_ammo - 1
		
		flag_can_shoot_repeater = false
		
		var bullet_info = get_bullet_spawn_info()
		
		var bullet = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
		bullet.position = bullet_info[0]
		bullet.rotation_degrees = bullet_info[1]
		bullet.bullet_type = bullet_info[2]
		
		var bullet_movement = get_bullet_movement(bullet_info[2], bullet_info[1])
		
		bullet_movement.y = Tools.get_rng_from_range(-10, 10)
		
		bullet.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation))
		
		get_parent().add_child(bullet)
		
		$repeater_wait_timer.start()
	elif Input.is_action_just_pressed("shoot") and PlayerProgress.repeater_current_ammo == 0 and PlayerProgress.current_player_gun == 2:
		show_empty()
	
	
	if movement.x < ACCELLERATION * underwater_multiplier and movement.x > -ACCELLERATION * underwater_multiplier:
		movement.x = 0
	
	var floor_norm = get_floor_normal()
	var slide = false
	if floor_norm != Vector2.UP:
		slide = true
	else:
		slide = false
	
	snap.y = snap.y * underwater_multiplier
	
	move_and_slide_with_snap(movement, snap, Vector2.UP, slide).y
	#move_and_slide(movement).x
	
	if is_on_the_floor:
		position.y = ceil(position.y)
	
	PlayerProgress.player_pos = position
	PlayerProgress.player_movement = movement


func animate():
	
	if anim_walk_frame == 0 and is_on_the_floor:
		$player_sprite/jetpack.position = Vector2.ZERO
	else:
		$player_sprite/jetpack.position = Vector2(0, -1)
	
	if PlayerProgress.current_player_gun != 3:
		anim_weapon_offset = PlayerProgress.current_player_gun
	else:
		if PlayerProgress.wrench_has_spawned:
			anim_weapon_offset = 0
		else:
			anim_weapon_offset = 3
	
	if flag_animating:
		if anim_movement.x == -1:
			$player_sprite.flip_h = true
			$player_sprite/jetpack.flip_h = true
			$player_sprite/jetpack/particles.position.x = 3
			flag_facing_right = false
		elif anim_movement.x == 1:
			$player_sprite.flip_h = false
			$player_sprite/jetpack.flip_h = false
			$player_sprite/jetpack/particles.position.x = -4
			flag_facing_right = true
		
		if not is_on_the_floor:
			if Input.is_action_pressed("look_down"):
				$player_sprite.frame = (anim_weapon_offset * 5) + 19
			elif Input.is_action_pressed("look_up"):
				$player_sprite.frame = (anim_weapon_offset * 5) + 18
			else:
				$player_sprite.frame = (anim_weapon_offset * 5) + 16
		else:
			if anim_movement.x != 0:
				$player_sprite/animator.play("walk")
				if Input.is_action_pressed("look_up"):
					$player_sprite.frame = (anim_weapon_offset * 5) + 17 + anim_walk_frame
				else:
					$player_sprite.frame = (anim_weapon_offset * 5) + 15 + anim_walk_frame
			else:
				$player_sprite/animator.stop(true)
				anim_walk_frame = 0
				if Input.is_action_pressed("look_up"):
					$player_sprite.frame = (anim_weapon_offset * 5) + 17
				else:
					$player_sprite.frame = (anim_weapon_offset * 5) + 15


func _input(event):
	
	if PlayerProgress.current_player_gun != 2:
		
		if Input.is_action_just_pressed("shoot"): # Shooting Code for everything else
			
			if PlayerProgress.current_player_gun == 1: # Pistol
				
				var bullet_info = get_bullet_spawn_info()
				
				var bullet = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
				bullet.position = bullet_info[0]
				bullet.rotation_degrees = bullet_info[1]
				bullet.bullet_type = bullet_info[2]
				
				var bullet_movement = get_bullet_movement(bullet_info[2], bullet_info[1])
				
				bullet.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation))
				
				get_parent().add_child(bullet)
				
			
			elif PlayerProgress.current_player_gun == 5: # Thunder
				
				var bullet_info = get_bullet_spawn_info()
				
				var bullet = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
				bullet.position = bullet_info[0]
				bullet.rotation_degrees = bullet_info[1]
				bullet.bullet_type = bullet_info[2]
				
				var bullet_movement = get_bullet_movement(bullet_info[2], bullet_info[1])
				
				bullet.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation))
				
				get_parent().add_child(bullet)
			
			if PlayerProgress.current_player_gun == 3 and not PlayerProgress.wrench_has_spawned: # Blade
				
				if PlayerProgress.player_stuff.blade_level == 3:
					
					PlayerProgress.wrench_has_spawned = true
					
					var bullet_info = get_bullet_spawn_info()
					
					var bullet = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
					bullet.position = bullet_info[0]
					bullet.rotation_degrees = bullet_info[1]
					bullet.bullet_type = bullet_info[2]
					var bullet2 = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
					bullet2.position = bullet_info[0]
					bullet2.rotation_degrees = bullet_info[1] + 20
					bullet2.bullet_type = "blade_clone"
					var bullet3 = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
					bullet3.position = bullet_info[0]
					bullet3.rotation_degrees = bullet_info[1] - 20
					bullet3.bullet_type = "blade_clone"
					
					var bullet_movement = get_bullet_movement(bullet_info[2], bullet_info[1])
					
					bullet.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation))
					bullet2.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet2.rotation))
					bullet3.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet3.rotation))
					
					get_parent().add_child(bullet)
					get_parent().add_child(bullet2)
					get_parent().add_child(bullet3)
					
				else:
					
					PlayerProgress.wrench_has_spawned = true
					
					var bullet_info = get_bullet_spawn_info()
					
					var bullet = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
					bullet.position = bullet_info[0]
					bullet.rotation_degrees = bullet_info[1]
					bullet.bullet_type = bullet_info[2]
					
					var bullet_movement = get_bullet_movement(bullet_info[2], bullet_info[1])
					
					bullet.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation))
					
					get_parent().add_child(bullet)
					
			
			if PlayerProgress.current_player_gun == 4: # Shotgun
				
				if PlayerProgress.shotgun_current_ammo != 0:
					
					PlayerProgress.shotgun_current_ammo = PlayerProgress.shotgun_current_ammo - 1
					
					if PlayerProgress.player_stuff.shotgun_level == 1 or PlayerProgress.player_stuff.shotgun_level == 2:
						
						var bullet_info = get_bullet_spawn_info()
						
						var bullet = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
						bullet.position = bullet_info[0]
						bullet.rotation_degrees = bullet_info[1]
						bullet.bullet_type = bullet_info[2]
						
						var bullet2 = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
						bullet2.position = bullet_info[0]
						bullet2.rotation_degrees = bullet_info[1]
						bullet2.bullet_type = bullet_info[2]
						
						var bullet3 = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
						bullet3.position = bullet_info[0]
						bullet3.rotation_degrees = bullet_info[1]
						bullet3.bullet_type = bullet_info[2]
						
						var bullet_movement = get_bullet_movement(bullet_info[2], bullet_info[1])
						
						bullet.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation))
						bullet2.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation + 0.25))
						bullet3.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation - 0.25))
						
						get_parent().add_child(bullet)
						get_parent().add_child(bullet2)
						get_parent().add_child(bullet3)
						
					else:
						
						var bullet_info = get_bullet_spawn_info()
						
						var bullet = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
						bullet.position = bullet_info[0]
						bullet.rotation_degrees = bullet_info[1]
						bullet.bullet_type = bullet_info[2]
						var bullet2 = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
						bullet2.position = bullet_info[0]
						bullet2.rotation_degrees = bullet_info[1]
						bullet2.bullet_type = bullet_info[2]
						var bullet3 = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
						bullet3.position = bullet_info[0]
						bullet3.rotation_degrees = bullet_info[1]
						bullet3.bullet_type = bullet_info[2]
						var bullet4 = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
						bullet4.position = bullet_info[0]
						bullet4.rotation_degrees = bullet_info[1]
						bullet4.bullet_type = bullet_info[2]
						var bullet5 = preload("res://assets/scenes/gameplay/player/bullet.tscn").instance()
						bullet5.position = bullet_info[0]
						bullet5.rotation_degrees = bullet_info[1]
						bullet5.bullet_type = bullet_info[2]
						
						var bullet_movement = get_bullet_movement(bullet_info[2], bullet_info[1])
						
						bullet.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation))
						bullet2.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation + 0.2))
						bullet3.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation - 0.2))
						bullet4.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation + 0.4))
						bullet5.apply_impulse(Vector2.ZERO, bullet_movement.rotated(bullet.rotation - 0.4))
						
						
						get_parent().add_child(bullet)
						get_parent().add_child(bullet2)
						get_parent().add_child(bullet3)
						get_parent().add_child(bullet4)
						get_parent().add_child(bullet5)
				else:
					show_empty()


func get_bullet_spawn_info():
	
	var gun
	var dir
	var updir
	var actual_direction
	var bullet_type
	
	if PlayerProgress.current_player_gun == 1:
		gun = "pistol/"
		bullet_type = "pistol"
	elif PlayerProgress.current_player_gun == 2:
		gun = "repeater/"
		bullet_type = "repeater"
	elif PlayerProgress.current_player_gun == 3:
		gun = "blade/"
		bullet_type = "blade"
	elif PlayerProgress.current_player_gun == 4:
		gun = "shotgun/"
		bullet_type = "shotgun"
	else:
		gun = "thunder/"
		bullet_type = "thunder"
	
	if flag_facing_right:
		dir = "right"
		actual_direction = 0
	else:
		dir = "left"
		actual_direction = 180
	
	if Input.is_action_pressed("look_down") and not is_on_the_floor:
		updir = "_down"
		actual_direction = 90
	elif Input.is_action_pressed("look_up"):
		updir = "_up"
		actual_direction = 270
	else:
		updir = ""
	
	var correct_point = get_node_or_null(str("shooting_points/", gun, dir, updir))
	
	if correct_point == null:
		
		return [$shooting_points/pistol/right.global_position, 0, bullet_type]
		
	else:
		if updir != "_down":
			if anim_walk_frame == 0 and is_on_the_floor:
				return [correct_point.global_position, actual_direction, bullet_type]
			else:
				return [Vector2(correct_point.global_position.x, correct_point.global_position.y - 1), actual_direction, bullet_type]
		else:
			return [correct_point.global_position, actual_direction, bullet_type]
	


func get_bullet_movement(bullet_type, dir):
	
	var bullet_movement = Vector2.ZERO
	
	if bullet_type == "pistol":
		bullet_movement.x = 225
	elif bullet_type == "repeater":
		bullet_movement.x = 180
	elif bullet_type == "blade":
		bullet_movement.x = 150
	elif bullet_type == "thunder":
		bullet_movement.x = 300
	else:
		bullet_movement.x = 150
	
	return bullet_movement


func _on_repeater_wait_timer_timeout():
	flag_can_shoot_repeater = true


func show_empty():
	var empty = preload("res://assets/scenes/ui/hud/empty_label.tscn").instance()
	empty.position = global_position
	get_parent().add_child(empty)


func _on_coyote_time_timeout():
	coyote_time = false


func _on_other_collisions_area_entered(area):
	if area.is_in_group("water"):
		underwater_multiplier = 0.5
		if movement.y >= TERMINAL_VELOCITY / 2:
			$sfx/water.play()
			var particles = preload("res://assets/scenes/particles/player/water_particles.tscn").instance()
			particles.global_position = self.global_position + Vector2.DOWN * 5
			get_parent().call_deferred("add_child", particles)
			particles.emitting = true


func _on_other_collisions_area_exited(area):
	if area.is_in_group("water"):
		underwater_multiplier = 1
		$sfx/water.play()
		var particles = preload("res://assets/scenes/particles/player/water_particles.tscn").instance()
		particles.global_position = self.global_position + Vector2.DOWN * 5
		get_parent().call_deferred("add_child", particles)
		particles.emitting = true
