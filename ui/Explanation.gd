extends Control

export(String) var title = "" setget set_title
export(String, MULTILINE) var explanation = "" setget set_explanation

func _ready():
	$AnimationPlayer.play("Loading")

func set_title(t):
	$ColorRect/Title.text = t

func set_explanation(e):
	$ColorRect/Content.text = e

func ready_up():
	$AnimationPlayer/Loading.visible = false
	$ColorRect/Waiting.visible = true
	$ColorRect/NextButtons.visible = false

func _on_game_stopped():
	$ColorRect/Waiting.visible = false
	$ColorRect/NextButtons.visible = true

