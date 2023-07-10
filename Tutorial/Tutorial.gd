extends Node2D

var running = false
var explanation
var step = 0

# 0 - WALK TO THE RIGHT
# 1 - WALK TO THE LEFT
# 2 - BALANCE SEE SAW IN THE MIDDLE
# 3 - SPAWN A (COLORED?) OBSTACLE RIGHT
# 4 - SPAWN OBSTACLE LEFT
# 5 - SPAWN OBSTACLES ON BOTH SIDES?

var successes = 0 #relevant when two obstacles are spawned

func _ready():
	running = true
	var move = "tilt your controller" if GameSettings.motion else "press the right button."
	set_explanation("This is you.\nTo move your character to the right, " + move)

func set_explanation(text):
	$Instruction/Label.text = text

func _on_left_reached(body):
	if !body.is_in_group("players"):
		return
	if step == 1:
		$Blocks/SuccessAudio.play()
		set_explanation("Now try to balance the see saw evenly")
		$Timer.start(1.0)

func _on_right_reached(body):
	if !body.is_in_group("players"):
		return
	if step == 0:
		step = 1
		$Blocks/SuccessAudio.play()
		set_explanation("Now walk to the left")

func _on_scales_even():
	if step == 2:
		step = 3
		$Blocks/SuccessAudio.play()
		set_explanation("Great Job!\nDuring the game, obstacles will spawn underneath the see saw. Try to avoid them by moving the see saw. The outline indicates the size the obstacle will grow to.")
		$Timer.start(4.0)

func _on_Timer_timeout():
	if (step == 1):
		step = 2
	elif (step == 3):
		$Blocks.spawn_block(true)
	elif (step == 4):
		$Blocks.spawn_block(false)
	elif (step == 5):
		$Blocks.spawn_two_blocks()
		successes = 0

func _on_Blocks_succeeded():
	if (step == 3):
		set_explanation("Blocks can spawn on either side of the middle")
		step = 4
		$Timer.start(1.0)
	elif (step == 4):
		set_explanation("Sometimes blocks will spawn on both sides at once.\nTry to keep the see saw even to avoid them")
		step = 5
		$Timer.start(2.0)
	elif (step == 5):
		successes += 1
		if successes < 2:
			return
		set_explanation("Congrats!\nYou completed the tutorial.\nPress any button to join the game.")
		$Scales.set_physics_process(false)
		$Players/Player.set_process(false)
		$Players/Player.game_stopped()
		
		if JoyCon.connect("button_pressed", self, "joycon_button_pressed") != OK:
			print("could not connect button pressed signal")

func joycon_button_pressed(_button):
	if get_tree().change_scene("res://BalanceGame/BalanceGame.tscn") != OK:
		print("failed to start balance game")

func _on_Blocks_failed():
	$Timer.start(2.0)
