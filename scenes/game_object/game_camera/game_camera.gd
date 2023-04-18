extends Camera2D

var target_position = Vector2.ZERO

const player_util = preload("res://utility/player_utilty/player_utility.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_target_position()
	update_global_position(delta)


func update_target_position() -> void:
	player_util.find_player(self).for_each(func(p: Node2D):
		target_position = p.global_position
	)


func get_smooth_value(delta) -> float:
	return 1.0 - exp(-delta * 20)


func update_global_position(delta) -> void:
	global_position = global_position.lerp(target_position, get_smooth_value(delta))
	
	
