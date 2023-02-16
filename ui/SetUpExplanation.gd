extends Control

func _ready():
	if JoyCon.get_side() == "right":
		$Hold/HoldLeft.visible = false
		$Start/StartLeft.visible = false
		$MotionMode/MoveLeft.visible = false
		$ButtonMode/MoveLeft.visible = false
		
		$Hold/HoldRight.visible = true
		$Start/StartRight.visible = true
		$MotionMode/MoveRight.visible = true
		$ButtonMode/MoveRight.visible = true
		
	if GameSettings.asymmetric:
		$AsyncExplanation.visible = true

	if !GameSettings.motion:
		$ButtonMode.visible = true
		$MotionMode.visible = false
