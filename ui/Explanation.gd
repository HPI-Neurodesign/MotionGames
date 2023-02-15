extends Control

func _ready():
	$AnimationPlayer.play("Loading")
	#todo: only do this in the actual balance game
	if JoyCon.get_side() == "right":
		$Background/BalanceGame/HoldLeft.visible = false
		$Background/BalanceGame/StartLeft.visible = false
		$Background/BalanceGame/TiltLeft.visible = false
		
		$Background/BalanceGame/HoldRight.visible = true
		$Background/BalanceGame/StartRight.visible = true
		$Background/BalanceGame/TiltRight.visible = true

func ready_up():
	$AnimationPlayer/Loading.visible = false
	$Background/Waiting.visible = true

func _on_game_stopped():
	$Background/Waiting.visible = false
