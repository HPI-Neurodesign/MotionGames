extends KinematicBody2D

const MaxRotation = 0.3
const speed = 0.001

signal even

var time_even = 0
var time_even_count = 1.5

func _physics_process(delta):
	var players = get_tree().get_nodes_in_group("players")
	var total_tilt = 0
	for p in players:
		if not p.on_floor:
			continue
		total_tilt += p.position.x
	
	rotation += total_tilt * speed * delta
	rotation = clamp(rotation, -MaxRotation, MaxRotation)
	for p in players:
		p.rotation = rotation
	
	if abs(rotation) < 0.1:
		time_even += delta
		if (time_even >= time_even_count):
			emit_signal("even")
			time_even = 0
	else:
		time_even = 0
