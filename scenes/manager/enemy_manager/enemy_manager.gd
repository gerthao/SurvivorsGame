extends Node

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer: Timer = $Timer


const player_util            = preload("res://utility/player_utilty/player_utility.gd")
const SPAWN_RADIUS: float    = 375
const BASE_SPAWN_TIME: float = 5
const TIME_OFF_CLAMP: float  = .7

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(on_timeout)
	arena_time_manager.difficulty_increased.connect(on_difficulty_increased)


func on_timeout() -> void:
	timer.start()
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


func on_difficulty_increased(difficulty: float) -> void:
	var time_off    = (.1 / 12) * difficulty
	time_off        = min(time_off, TIME_OFF_CLAMP)
	timer.wait_time = BASE_SPAWN_TIME - time_off
