tool
extends RichTextEffect
class_name RichTextRed

var bbcode = "red"

func _process_custom_fx(char_fx):
	
	char_fx.color = Color(1, 0, 0)
	
	return true
