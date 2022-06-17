extends KinematicBody2D

const MaxRotation = 0.3
const speed = 0.001

func _ready():
	set_physics_process(false)

func _on_game_stopped():
	rotation = 0
	set_physics_process(false)

func _on_game_started():
	set_physics_process(true)

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
