extends KinematicBody2D

var moved = false

func _ready():
	
	$cam.drag_margin_left = 0
	$cam.drag_margin_right = 0
	$cam.drag_margin_top = 0
	$cam.drag_margin_bottom = 0
	

func _physics_process(delta):
	
	var parent_pos = get_parent().global_position
	var difference = parent_pos - global_position
	
	if difference != Vector2.ZERO and moved == false:
		$cam.drag_margin_left = 0.075
		$cam.drag_margin_right = 0.075
		$cam.drag_margin_top = 0.075
		$cam.drag_margin_bottom = 0.075
	
	move_and_slide(difference, Vector2.UP)
	self.position = Vector2(round(position.x), round(position.y))
	
