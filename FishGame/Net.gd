extends Area2D

signal set_player_ready
signal net_up

var fishes = []

var forward = true
var original_scale

var ready = true

func _ready():
	set_process(false)
	original_scale = scale

func _on_game_started():
	set_process(true)

remotesync func move_up():
	if (ready):
		ready = false
		$Tween.interpolate_property(self, "scale", original_scale, original_scale * 1.1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		forward = true
		emit_signal("net_up", true)
		
		for f in fishes:
			if is_network_master():
				$"../UI/".update_score(f.points)
			f.on_caught()

func _on_Net_body_entered(body):
	if body.is_in_group("fish"):
		fishes.push_back(body)

func _on_Net_body_exited(body):
	if body.is_in_group("fish"):
		fishes.erase(body)

func _on_game_stopped():
	set_process(false)

func _on_tween_completed(_object, _key):
	if (forward):
		forward = false
		$Tween.interpolate_property(self, "scale", scale, original_scale, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		ready = true
		emit_signal("net_up", false)
		emit_signal("set_player_ready", false)
