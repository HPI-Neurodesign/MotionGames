extends Node2D
class_name MiniGame

signal start
signal stop

var running = false

func _ready():
	if $"..".connect("player_joined", self, "player_joined") != OK:
		print("connecting signal failed")
	if $"..".connect("player_left", self, "player_left") != OK:
		print("connecting signal failed")

func _physics_process(_delta):
	if OS.has_feature("editor") and not running and Input.is_action_just_pressed("start"):
		rpc("start_game")
	if is_network_master() and not running and get_tree().get_nodes_in_group("players").size() > 0:
		for p in get_tree().get_nodes_in_group("players"):
			if not p.ready_to_start:
				return
		rpc("start_game")

func player_joined(_player, _game):
	pass

func player_left(_player, _game):
	if get_tree().get_nodes_in_group("players").size() == 0:
		rpc("reset")

remotesync func reset():
	$Explanation/Popup.popup()
	stop_game()

func ready_up():
	$Explanation.ready_up()

remotesync func start_game():
	$Explanation.visible = false
	$UI/Timer.start()
	running = true
	emit_signal("start")

func stop_game():
	emit_signal("stop")
	running = false
	#TODO Score setting
	#$Explanation.visible = true
	#$Explanation.explanation = "Finished!\nYour score is " + str($UI.score)

func _on_timeout():
	stop_game()
