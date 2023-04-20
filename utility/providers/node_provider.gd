extends Node

static func find_node_in_group(node: Node, group_name: String) -> Optional:
	return Optional.new(node.get_tree().get_first_node_in_group(group_name))
	

static func nodes_in_group(node: Node, group_name: String) -> Array[Node]:
	return node.get_tree().get_nodes_in_group(group_name)
