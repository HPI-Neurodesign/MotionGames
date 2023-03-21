extends Control
var game = "Balance"

func joycon_button_pressed(_button_name):
	start_game()

func _ready():
	var args = OS.get_cmdline_args()
	if "--german" in args:
		TranslationServer.set_locale("de")
	if "--dedicated" in args:
		if "--asymmetric" in args:
			GameSettings.asymmetric = true
	if "--motion" in args:
		GameSettings.motion = true
	if "--buttons" in args:
		GameSettings.motion = false
	if not "--dedicated" in args:
		JoyCon.init()
		JoyCon.set_controller(0)
		JoyCon.show_indicator()
		if JoyCon.connect("button_pressed", self, "joycon_button_pressed") != OK:
			print("could not connect button pressed signal")
	
	for argument in args:
		print(argument)
		if argument.find("--game=") > -1:
			#start_game(argument.split("=")[1])
			game = argument.split("=")[1]
		#TODO should probably allow skipping the tutorial

func start_game():
	print("Starting game " + str(game))
	GameSettings.set_port(game)
	if game == "Balance":
		if get_tree().change_scene("res://Tutorial/TutorialBalance.tscn") != OK:
			print("failed to start the tutorial game")
		# TODO start this after running the tutorial
		#if get_tree().change_scene("res://BalanceGame/BalanceGame.tscn") != OK:
		#	print("failed to start balance game")
	elif game == "Fish":
		if get_tree().change_scene("res://FishGame/FishGame.tscn") != OK:
			print("failed to start fish game")
	else:
		print("Unsupported game tag given: " + game.toString())
