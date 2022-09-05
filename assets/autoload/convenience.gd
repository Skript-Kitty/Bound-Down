extends Node


func get_rng_from_range(low, high):
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var return_number = rng.randf_range(low, high)
	
	return return_number

func toggle_true_false(var_to_change, from):
	
	if typeof(var_to_change) != TYPE_BOOL:
		ErrorHandler.throw_error_to_console(str("Err Tried to toggle a bool, but it wasn't a bool.\nFrom ", str(from)))
		return null
	else:
		if var_to_change == true:
			var_to_change = false
		else:
			var_to_change = true
	
	return var_to_change
	
