extends Node2D
signal failed
signal succeeded

func spawn_two_blocks():
	var right_block = preload("res://Tutorial/Block.tscn").instance()
	right_block.tint_color = Color.red
	right_block.side = 0
	right_block.size = 3 
	add_child(right_block)
	
	var left_block = preload("res://Tutorial/Block.tscn").instance()
	left_block.tint_color = Color.red
	left_block.side = 1
	left_block.size = 3
	add_child(left_block)

func spawn_block(side, player = null):
	var block = preload("res://Tutorial/Block.tscn").instance()
	block.tint_color = player.colors[1] if player else Color.red
	block.size = 0 #+ floor(blocks_spawned / 7)
	block.side = 1 if side else 0
	add_child(block)

func on_failure():
	$ErrorAudio.play()
	$"../ShakeCamera2D".add_trauma(0.5)
	emit_signal("failed")

func on_success():
	$SuccessAudio.play()
	emit_signal("succeeded")
