extends Node2D

var MaxCooldown = 5
var cooldown = MaxCooldown
var blocks_spawned = 0

func _reset_vars():
	blocks_spawned = 0
	MaxCooldown = 5
	cooldown = MaxCooldown
	set_process(false)

func _ready():
	set_process(false)

func _on_game_started():
	set_process(true)

func _on_game_stopped():
	set_process(false)
	_reset_vars()
	if is_network_master():
		for child in get_tree().get_nodes_in_group("block"):
			child.queue_free()


var order = ["l", "r", "l", "l", "b", "r", "l", "r", "l", "b", "l", "b", "r", "l", "l", "r", "b", "l", "r", "b", "l", "r"]
func _process(delta):
	if is_network_master():
		cooldown -= delta
		if cooldown <= 0:
			cooldown = MaxCooldown
			MaxCooldown -= 0.08
			
			var next = order[blocks_spawned]
			
			var player
			if GameSettings.asymmetric:
				var players = get_tree().get_nodes_in_group("players")
				player = players[blocks_spawned % players.size()]
			
			blocks_spawned += 1
			
			if next == "r":
				spawn_block(false, player)
			elif next == "l":
				spawn_block(true, player)
			else:
				spawn_two_blocks()

func spawn_two_blocks():
	var right_block = preload("res://BalanceGame/Block.tscn").instance()
	right_block.tint_color = Color.red
	right_block.visible = true
	right_block.side = 0
	right_block.size = 3 + floor(blocks_spawned / 7)
	add_child(right_block)
	
	var left_block = preload("res://BalanceGame/Block.tscn").instance()
	left_block.tint_color = Color.red
	left_block.visible = true
	left_block.side = 1
	left_block.size = 3 + floor(blocks_spawned / 7) 
	add_child(left_block)

func spawn_block(side, player = null):
	var block = preload("res://BalanceGame/Block.tscn").instance()
	block.tint_color = player.colors[1] if player else Color.red
	block.size = 0 + floor(blocks_spawned / 7)
	block.side = 1 if side else 0
	add_child(block)

func on_failure():
	rpc("_on_failure")
func on_success():
	rpc("_on_success")

remotesync func _on_failure():
	$ErrorAudio.play()
	$"../ShakeCamera2D".add_trauma(0.5)

remotesync func _on_success():
	$SuccessAudio.play()
