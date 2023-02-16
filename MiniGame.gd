extends KinematicBody2D
class_name MiniGamePlayer

var ready_to_start = false setget set_ready_to_start
var top_pressed = false

func set_ready_to_start(ready):
	ready_to_start = ready

func game_stopped():
	ready_to_start = false
	$YouLabel.visible = false

func game_started():
	if is_network_master():
		$YouLabel.visible = true

func on_button_released(_button_name):
	pass

func on_button_pressed(button_name):
	if is_network_master():
		set_ready_to_start(true)
		$"../..".ready_up()
	#TODO only when in game
	#if button_name == "top" and is_network_master():
	#	if top_pressed:
	#		$"../..".rpc("reset")
	#		top_pressed = false
	#	else:
	#		top_pressed = true
	#		yield(get_tree().create_timer(0.5), "timeout")
	#		top_pressed = false

func _ready():
	$Sync.add_property("synced", "ready_to_start")
	if $"../..".connect("stop", self, "game_stopped") != OK:
		print("an error occured while connecting the signal")
	if $"../..".connect("start", self, "game_started") != OK:
		print("an error occured while connecting the signal")

func setup_joycons():
	if JoyCon.connect("button_pressed", self, "on_button_pressed") != OK:
		print("could not connect button pressed signal")
	if JoyCon.connect("button_released", self, "on_button_released") != OK:
		print("could not connect button pressed signal")
	JoyCon.show_indicator()
