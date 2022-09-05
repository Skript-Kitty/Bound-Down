tool
extends RichTextEffect
class_name RichTextGreen

var bbcode = "green"

func _process_custom_fx(char_fx):
	
	char_fx.color = Color(0, 1, 0)
	
	return true
