extends Node

@export var basic_enemy_scene: PackedScene

const SPAWN_RADIUS = 375
const player_util  = preload("res://utility/player_utilty/player_utility.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timeout)


func on_timeout() -> void:
	player_util.with_player(self, spawn_enemy)


func spawn_enemy(player: Node2D) -> void:
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position   = player.global_position + (random_direction * SPAWN_RADIUS)
	var enemy            = basic_enemy_scene.instantiate() as Node2D
	get_entities_layer().for_each(func(entities_layer: Node2D):
		entities_layer.add_child(enemy)
	)
	enemy.global_position = spawn_position
	

func get_entities_layer():
	return Optional.new(get_tree().get_first_node_in_group("entities_layer"))
