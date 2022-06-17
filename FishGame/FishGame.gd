extends MiniGame

func _process(_delta):
	if is_network_master():
		for p in get_tree().get_nodes_in_group("players"):
			if not p.ready:
				return
		$Net.rpc("move_up")
		for p in get_tree().get_nodes_in_group("players"):
			p.ready = false

