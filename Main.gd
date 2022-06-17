extends Control

var group: ButtonGroup

var selection
var device_count
const MaxSelection = 3

var timeout = 0
const MaxTimeout = 0.2

func _draw():
	var color = Color("ff4c4c")
	var width = 4.0
	if selection == null:
		return
	if selection == 0:
		draw_rect(Rect2(386, 240, 252, 56), color, false, width)
	elif selection == 1:
		draw_rect(Rect2(386, 320, 252, 56), color, false, width)
	elif selection == 2:
		draw_rect(Rect2(180, 405, 250, 90), color, false, width)
	elif selection == 3:
		draw_rect(Rect2(610, 405, 250, 90), color, false, width)

func joycon_button_pressed(button_name):
	if selection == null:
		return
	if not button_name == "right" and not button_name == "top":
		return
	if selection == 0:
		$Motion.pressed = not GameSettings.is_motion_enabled()
	elif selection == 1:
		$Asymmetric.pressed = not GameSettings.is_asymmetric()
	elif selection == 2:
		$FishGame.emit_signal("pressed")
	elif selection == 3:
		$BlanceGame.emit_signal("pressed")

func _ready():
	var args = OS.get_cmdline_args()
	if "--dedicated" in args:
		if "--asymmetric" in args:
			GameSettings.asymmetric = true
		for argument in args:
			if argument.find("game=") > -1:
				start_game(argument.split("=")[1])
	else:
		JoyCon.init()
		get_controllers()
		if JoyCon.connect("button_pressed", self, "joycon_button_pressed") != OK:
			print("could not connect button pressed signal")

func start_game(game):
	print("Starting game " + str(game))
	GameSettings.set_port(game)
	if game == "Balance":
		if get_tree().change_scene("res://BalanceGame/BalanceGame.tscn") != OK:
			print("failed to start balance game")
	elif game == "Fish":
		if get_tree().change_scene("res://FishGame/FishGame.tscn") != OK:
			print("failed to start fish game")
	else:
		print("Unsupported game tag given: " + game)

func _on_Blance_Game_pressed():
	_play_click()
	start_game("Balance")

func _on_Fish_Game_pressed():
	_play_click()
	start_game("Fish")

func _on_Asymmetric_toggled(button_pressed):
	GameSettings.set_asymmetric(button_pressed)

func _on_Motion_toggled(button_pressed):
	GameSettings.set_motion_enabled(button_pressed)

func _process(delta):
	for i in JoyCon.device_count:
		if JoyCon.any_button_pressed(i):
			$ControllerCheckboxes.get_child(i + 1).pressed = true
	
	timeout -= delta
	if timeout < 0:
		var stick = JoyCon.get_joystick()
		if abs(stick.x) > 0.7:
			timeout = MaxTimeout
			if stick.x > 0:
# warning-ignore:incompatible_ternary
				selection = 0 if selection == null else min(MaxSelection, selection + 1)
			else:
# warning-ignore:incompatible_ternary
				selection = 0 if selection == null else max(0, selection - 1)
			update()

func controller_button_pressed(button):
	if button.index != JoyCon.get_controller_index():
		JoyCon.set_controller(button.index)
		_play_click()

func setup_controller(index):
	var checkbox = preload("res://ui/EnumeratedCheckBox.tscn").instance()
	var x = 512 + (index - floor(JoyCon.device_count / 2)) * 150
	checkbox.rect_position = Vector2(x, 0)
	checkbox.group = group
	checkbox.set_index(index)
	checkbox.pressed = true if index == 0 else false
	$ControllerCheckboxes.add_child(checkbox)

func get_controllers():
	if JoyCon.device_count == 0:
		$ControllerCheckboxes/NoControllers.visible = true
	
	group = ButtonGroup.new()
	if group.connect("pressed", self, "controller_button_pressed") != OK:
		print("could not connect controller button pressed signal")
	for i in JoyCon.device_count:
		setup_controller(i)

func _play_click():
	$Click.play()
