extends Control

export(String) var gametype = "" setget set_game

func _ready():
	$AnimationPlayer.play("Loading")

func ready_up():
	$AnimationPlayer/Loading.visible = false
	$Background/Waiting.visible = true

func _on_game_stopped():
	$Background/Waiting.visible = false

func set_game(type):
	if type == "balance":
		$Background/BalanceGame.visible = true
	elif type == "fishing":
		$Background/FishingGame.visible = true

func set_final_score(text):
	visible = true
	$Background/BalanceGame.visible = false
	$Background/FishingGame.visible = false
	$Background.visible = true
	$Background/FinalScore.visible = true
	$Background/FinalScore.text = text
