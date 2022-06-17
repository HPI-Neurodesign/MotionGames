extends KinematicBody2D

var speed
var moving = true
var color setget set_color
var points = 0
var index

func set_color(new_color):
	color = new_color
	if (color == 0):
		$"PinkFish".visible = true
		visible = false
		speed = 250
		points = 5
	else:
		$"GreenFish".visible = true
		speed = 200
		points = 1

func on_caught():
	moving = false
	$Tween.interpolate_property(self, "scale", scale, Vector2(5, 5), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a", modulate.a, 0.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	if color == 0:
		$PinkFishCaught.play()
	else:
		yield(get_tree().create_timer(randf() * 0.1), "timeout")
		$GreenFishCaught.play()

func _process(delta):
	if (moving):
		var _collision = move_and_collide(Vector2(0, speed * delta))

func _on_VisibilityNotifier_screen_exited():
	if is_network_master():
		queue_free()

func _on_sound_finished():
	if is_network_master():
		queue_free()
