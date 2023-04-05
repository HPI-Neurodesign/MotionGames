extends KinematicBody2D

enum State {WalkingRight, WalkingLeft, Idle}

var speed = 200
var state = State.Idle
var gravity = 200
var on_floor = false

const ControllerThreshhold = 50
const SpawnPositions = [300, -300, 100, -100]

var offset
var player_count = 0
var colors setget set_block_colors

const matched_colors = {
	"green": Color.mediumspringgreen,
	"pink": Color.hotpink,
	"blue": Color.cornflower,
	"yellow": Color.yellow,
}

func set_block_colors(array):
	if array == null:
		return
	colors = array
	if colors[0] == "":
		modulate = colors[1]

var direction_pressed = 0

func game_stopped():
	on_floor = false
	position = Vector2(SpawnPositions[player_count], 200)
	rotation = 0
	$Sprite.play("idle_")

func _ready():
	setup_joycons()
	offset = $YouLabel.rect_position
	$YouLabel.visible = true
	$YouLabel.set_as_toplevel(true)
	$YouLabel.rect_position = Vector2(-100, -100)

func setup_joycons():
	if JoyCon.connect("button_pressed", self, "on_button_pressed") != OK:
		print("could not connect button pressed signal")
	if JoyCon.connect("button_released", self, "on_button_released") != OK:
		print("could not connect button pressed signal")
	JoyCon.show_indicator()

func on_button_pressed(button_name):
	if button_name == "right":
		direction_pressed = 1
	elif button_name == "left":
		direction_pressed = -1

func on_button_released(button_name):
	if button_name == "right" and direction_pressed == 1:
		direction_pressed = 0
	elif button_name == "left" and direction_pressed == -1:
		direction_pressed = 0
	
func _process(_delta):
	if  $"../..".running:
		$YouLabel.rect_position = global_position + offset
		var velocity = Vector2()
		velocity.y += gravity
		if Input.is_action_pressed("ui_right") or \
		   (JoyCon.xRotation > ControllerThreshhold and GameSettings.is_motion_enabled()) or \
		   (direction_pressed == 1 and not GameSettings.is_motion_enabled()):
			velocity.x += speed
			state = State.WalkingRight
		elif Input.is_action_pressed("ui_left") or \
			 (JoyCon.xRotation < -ControllerThreshhold and GameSettings.is_motion_enabled()) or \
			 (direction_pressed == -1 and not GameSettings.is_motion_enabled()):
			velocity.x -= speed
			state = State.WalkingLeft
		else:
			state = State.Idle
		var _movement = move_and_slide(velocity, Vector2.UP, true)
		if is_on_floor():
			on_floor = true
	
	var c = colors[0] if colors and len(colors) > 0 else "" 
	if state == State.Idle:
		$Sprite.play("idle_" + c)
	elif state == State.WalkingLeft:
		$Sprite.play("walk_" + c)
		$Sprite.flip_h = true
	elif state == State.WalkingRight:
		$Sprite.play("walk_" + c)
		$Sprite.flip_h = false
	
