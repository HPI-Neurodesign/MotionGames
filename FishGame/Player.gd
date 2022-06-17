extends MiniGamePlayer

const MAX_READY_TIME = 0.5

var countdown = MAX_READY_TIME

var ready = false setget set_ready
var color
var player_count = 0
var net_up = false setget set_net_up

var Colors = ["Blue", "Orange", "White", "Green"]

const PLAYER_POS_ROT = [
	[Vector2(384, 356), 40],
	[Vector2(384, 491), -40],
	[Vector2(644, 356), 140],
	[Vector2(644, 491), -140]
]

func _ready():
	set_physics_process(false)
	if $"../../Net".connect("set_player_ready", self, "set_ready") != OK:
		print("Signal set player ready could not be connected")
	if $"../../Net".connect("net_up", self, "set_net_up") != OK:
		print("Signal net up could not be connected")
	
	if is_network_master():
		setup_joycons()
		$YouLabel.visible = true
		$YouLabel.modulate = JoyCon.get_joycon_color()
	if color == "Blue":
		$Sprites/Blue.visible = true
		$Arms/BlueArm.visible = true
		$Arms/BlueArm2.visible = true
	elif color == "Green":
		$Sprites/Green.visible = true
		$Arms/GreenArm.visible = true
		$Arms/GreenArm2.visible = true
	elif color == "Orange":
		$Sprites/Orange.visible = true
		$Arms/OrangeArm.visible = true
		$Arms/OrangeArm2.visible = true
	else:
		$Sprites/White.visible = true
		$Arms/WhiteArm.visible = true
		$Arms/WhiteArm2.visible = true

func on_button_pressed(button_name):
	.on_button_pressed(button_name)
	if not ready and button_name == "right" and is_network_master() and not GameSettings.is_motion_enabled():
		set_ready(true)
		set_physics_process(true)

func _network_ready(is_source):
	player_count = -1
	for c in $"..".get_children():
		if c.name.begins_with('player'):
			player_count += 1
	if is_source:
		position = PLAYER_POS_ROT[player_count][0]
		rotation_degrees = PLAYER_POS_ROT[player_count][1]
		color = Colors[player_count]

func _process(_delta):
	if not ready and \
	  (Input.is_action_just_pressed("ui_up") #Allow using keyboard for debugging
	  or (JoyCon.moveUp > 150 and GameSettings.is_motion_enabled())): #if motion enabled
		set_ready(true)
		set_physics_process(true)
	
	for fish in $"../../Fishes".get_children():
		if fish is KinematicBody2D and \
		   (not GameSettings.asymmetric or \
		   (fish.color == 0 and fish.index == player_count)):
			fish.visible = true

func _physics_process(delta):
	countdown -= delta
	if (countdown <= 0):
		set_physics_process(false)
		countdown = MAX_READY_TIME
		set_ready(false)

func set_net_up(new):
	net_up = new
	modulate = Color.green if new else modulate

func set_ready(r):
	if net_up or r == ready:
		return
	ready = r
	for i in $Arms.get_children():
		i.play("Up", not r)
	modulate = Color.blue if r else Color.white
	if not r:
		countdown = MAX_READY_TIME
