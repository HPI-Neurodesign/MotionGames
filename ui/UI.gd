extends Control
signal timeout

var score = 0 setget set_score

func _process(_delta):
	$TimeLeft.text = str(round($Timer.time_left))

func update_score(delta):
	set_score(score + delta)

func set_score(s):
	score = s
	$CurrentScore.text = str(score)

func _on_timeout():
	emit_signal("timeout")

func _on_game_stopped():
	$Timer.stop()

func _on_game_started():
	$Timer.start(90) #Game Duration
	set_score(0)
