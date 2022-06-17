extends Node2D

var countdown = 0
var fish_spawned = 0

var fish_scene = preload("res://FishGame/Fish.tscn")
var rng = RandomNumberGenerator.new()

const freq = 5.5
const amplitude = 4
const addend = 1 / 6
const noise_scale = 18
const min_graph = 0.25
const max_graph = 12

var pink_fish_index = 0
const pink_fish_times = [12, 18, 30, 34, 41, 50, 61, 66, 69, 73, 75, 77, 80, 82, 84, 87, 95]

var noise = OpenSimplexNoise.new() 
var time_expired = 0

func _ready():
	noise.seed = 210
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	set_physics_process(false)

func _on_game_started():
	if is_network_master():
		set_physics_process(true)

func _on_game_stopped():
	set_physics_process(false)
	countdown = 0
	fish_spawned = 0
	pink_fish_index = 0
	time_expired = 0
	if is_network_master():
		for fish in get_tree().get_nodes_in_group("fish"):
			fish.queue_free()

func _physics_process(delta):
	time_expired += delta
	spawn_green_fish()
	spawn_pink_fish()

func spawn_pink_fish():
	if abs(time_expired - pink_fish_times[pink_fish_index]) < 0.01:
		_spawn_fish(0, pink_fish_index)
		pink_fish_index += 1

func spawn_green_fish():
	var current_second = floor(time_expired * 4) / 4
	var fish_to_spawn = round(get_point(current_second))
	if fish_to_spawn == 0:
		return
	var x_frames = 100 / 4 / fish_to_spawn
	var current_frame = (time_expired - current_second)
	for i in fish_to_spawn:
		if abs(floorToSixtieth(x_frames * i) - current_frame * 100 / 4) < 0.001:
			_spawn_fish(1)
			return

func floorToSixtieth(number):
	return floor(number * 60) / 60

func _spawn_fish(color, index = 0):
	if get_tree().get_nodes_in_group("players").size() == 0:
		return
	var fish = fish_scene.instance()
	fish.position.x = randi() % 120  + 512 - 60
	fish.position.y = -40
	fish.color = color
	fish.index = index % get_tree().get_nodes_in_group("players").size()
	add_child(fish)
	fish_spawned += 1

func get_point(i):
	#sine wave
	var height = -sin(i * freq) * amplitude
	#add noise
	height += noise.get_noise_1d(i) * noise_scale
	#add constant height
	height +=  i * addend
	height = max(min_graph, min(height, max_graph))
	return height
