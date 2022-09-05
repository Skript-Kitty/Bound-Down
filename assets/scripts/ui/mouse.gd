extends Sprite

var mouse = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	mouse = get_global_mouse_position()
	self.position = mouse

func _physics_process(_delta):
	mouse = get_global_mouse_position()
	self.position = mouse

#This makes the cursor use the game window instead of the pc's window.
#For more of that pixely goodness!
