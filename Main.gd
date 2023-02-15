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

func _ready():

	var args = OS.get_cmdline_args()
	if "--dedicated" in args:
		if "--asymmetric" in args:
			GameSettings.asymmetric = true
		for argument in args:
			if argument.find("game=") > -1:
				start_game(argument.split("=")[1])

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

func _play_click():
	$Click.play()
