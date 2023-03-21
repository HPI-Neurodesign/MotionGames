extends Area2D

var tint_color = Color.white setget set_color
var side = 0 setget set_side
 
var grow_speed = 0.8
var grow_after = 3
var spawn_pos
var original_scale

var size = 0 setget set_size
var max_size

func set_size(new):
	size = new
	if (size == 0):
		max_size = Vector2(7, 10)
	elif (size == 1):
		max_size = Vector2(7, 14)
	elif (size == 2):
		max_size = Vector2(7, 17)
	# Spawned on both sides
	elif (size == 3):
		max_size = Vector2(7, 7)
	elif (size == 4):
		max_size = Vector2(7, 8)
	else:
		max_size = Vector2(7, 9)


const SpawnPos = [
	Vector2(300, 500),
	Vector2(-300, 500)
]

var in_block = false

func set_side(new_side):
	side = new_side

func set_color(color):
	tint_color = color

func _network_ready(is_source):
	if is_source:
		spawn_pos = SpawnPos[side]
	
	original_scale = scale
	position = spawn_pos
	$Sprite.self_modulate = tint_color
	$Tween.interpolate_property($Sprite, "self_modulate", $Sprite.self_modulate, $Sprite.self_modulate + Color.white, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Sprite, "self_modulate", $Sprite.self_modulate + Color.white, $Sprite.self_modulate, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$Tween.start()
	
	#visible = false
	

func _physics_process(delta):
	if grow_after > 0:
		grow_after -= delta
	else:
		set_physics_process(false)
		if in_block and is_network_master():
			hit()
		$Tween.stop_all()
		$Tween.interpolate_property($CollisionShape2D, "scale", $CollisionShape2D.scale, max_size, 1, Tween.TRANS_LINEAR)
		$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, $Sprite.scale * max_size, 1, Tween.TRANS_LINEAR)
		$Tween.start()
		$Audio.play()
		$Sprite.self_modulate = tint_color

func _on_Block_entered(body):
	if body.is_in_group("scale") and is_network_master():
		if grow_after > 0:
			in_block = true
			return
		hit()

func _on_Block_exited(body):
	if body.is_in_group("scale") and is_network_master():
		in_block = false

func _on_tween_completed(object, key):
	if object == $Sprite and key == ":scale" and is_network_master():
		avoided()

func hit():
	$"../../UI".update_score(-10)
	$Audio.stop()
	$"..".on_failure()
	queue_free()

func avoided():
	$"../../UI/".update_score(10)
	$"..".on_success()
	$Audio.stop()
	queue_free()

func _draw():
	draw_set_transform_matrix(transform.inverse())
	
	var topLeft = position - max_size / 2 * Vector2(10, 20)
	var bottomRight = position + max_size / 2 * Vector2(10, 20)
	var topRight = position - max_size / 2 * Vector2(-10, 20)
	var bottomLeft = position - max_size / 2 * Vector2(10, -20) 
	draw_dashed_line(topRight, topLeft)
	draw_dashed_line(topLeft, bottomLeft)
	draw_dashed_line(bottomLeft, bottomRight)
	draw_dashed_line(topRight, bottomRight)

func draw_dashed_line(from, to):
	var width = 3
	var dash_length = 8
	var length = (to - from).length()
	var normal = (to - from).normalized()
	var dash_step = normal * dash_length
	
	if length < dash_length: #not long enough to dash
		draw_line(from, to, tint_color, width)
		return

	else:
		var draw_flag = true
		var segment_start = from
		var steps = length/dash_length
		for _i in range(0, steps + 1):
			var segment_end = segment_start + dash_step
			if draw_flag:
				draw_line(segment_start, segment_end, tint_color, width)
			segment_start = segment_end
			draw_flag = !draw_flag
