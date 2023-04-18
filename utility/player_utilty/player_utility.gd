static func with_player(s: Node, f: Callable) -> void:
	find_player(s).for_each(f)


static func find_player(s: Node) -> Optional:
	var player = s.get_tree().get_first_node_in_group("player") as Node2D
	return Optional.new(player)
