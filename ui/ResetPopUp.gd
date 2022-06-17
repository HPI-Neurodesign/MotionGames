extends Popup

func _on_Popup_about_to_show():
	yield(get_tree().create_timer(1.0), "timeout")
	hide()
