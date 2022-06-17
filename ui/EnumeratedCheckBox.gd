extends CheckBox

var index

func set_index(i):
	index = i
	text = JoyCon.get_joycon_color_as_string_for_index(index)
	modulate = JoyCon.get_joycon_color_for_index(index)
