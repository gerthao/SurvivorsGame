const GROUP_NAME = "entities_layer"

static func get_entities_layer(node: Node) -> Optional:
	return Optional.new(node.get_tree().get_first_node_in_group(GROUP_NAME))
