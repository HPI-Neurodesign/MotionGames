extends Node

var asymmetric = false
var motion = true
var port 

func _ready():
	TranslationServer.set_locale("en")

func set_asymmetric(new):
	asymmetric = new

func is_asymmetric():
	return asymmetric

func set_motion_enabled(new):
	motion = new

func is_motion_enabled():
	return motion

func set_port(game):
	port = get_port(game)

func get_port(game):
	if game == "Balance":
		if GameSettings.asymmetric:
			return 8882
		return 8881
	if game == "Fish":
		if GameSettings.asymmetric:
			return 8872
		return 8871
