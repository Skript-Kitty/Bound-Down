tool
extends RichTextEffect
class_name RichTextGray

var bbcode = "gray"

func _process_custom_fx(char_fx):
	
	char_fx.color = Color(0.5, 0.5, 0.5)
	
	return true
