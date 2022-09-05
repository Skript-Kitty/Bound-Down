tool
extends RichTextEffect
class_name RichTextYellow

var bbcode = "yellow"

func _process_custom_fx(char_fx):
	
	char_fx.color = Color(1, 1, 0)
	
	return true
