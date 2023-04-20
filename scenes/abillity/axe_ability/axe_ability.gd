extends Node2D
class_name AxeAbility

const BASE_RADIUS = 100
const player_util = preload("res://utility/player_utilty/player_utility.gd")

@onready var hitbox_component: HitboxComponent = $HitboxComponent


func _ready():
	var base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween         = create_tween()
	tween.tween_method(handle_rotation.bind(base_rotation), .0, 2., 3.0)
	tween.tween_callback(queue_free)
	

func handle_rotation(rotations: float, base_rotation: Vector2) -> void:
	var current_direction = base_rotation.rotated(rotations * TAU)
	var rotation_percent  = rotations / 2
	var current_radius    = rotation_percent * BASE_RADIUS
	
	global_position = get_axe_position() + (current_direction * current_radius)
	

func get_axe_position() -> Vector2:
	return player_util.find_player(self).fold(global_position, func(player: Node2D):
		return player.global_position	
	)
