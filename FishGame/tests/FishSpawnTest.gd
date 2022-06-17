extends Node2D

onready var freq = 5.5
onready var amplitude = 4
onready var addend = 1 / 6
onready var noise_scale = 18
onready var min_graph = 0.25
onready var max_graph = 12

var noise = OpenSimplexNoise.new() 

func _ready():
	noise.seed = 210
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

func get_point(i):
	#sine wave
	var height = -sin(i * freq) * amplitude
	#add noise
	height += noise.get_noise_1d(i) * noise_scale
	#add constant height
	height +=  addend * i
	height = max(min_graph, min(height, max_graph))
	return height

func _draw():
	for i in range(90):
		var point = Vector2(i, get_point(i))
		var point_next = Vector2(i + 1, get_point(i + 1))
		draw_line(
			point,
			point_next,
			Color.blue,
			1
		)

