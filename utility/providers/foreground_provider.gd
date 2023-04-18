const GROUP_NAME = "foreground"

static func get_foreground(node: Node) -> Optional:
	return Optional.new(node.get_tree().get_first_node_in_group(GROUP_NAME))
