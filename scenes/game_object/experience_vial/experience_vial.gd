extends Node2D

const player_util = preload("res://utility/player_utilty/player_utility.gd")

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite_2d = $Sprite2D



func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	

func on_area_entered(other_area: Area2D) -> void:
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(follow_player.bind(global_position), 0.0, 1.0, 0.55) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite_2d, "scale", Vector2.ZERO, 0.05).set_delay(0.45)
	tween.chain()
	tween.tween_callback(collect)


func follow_player(percent: float, start_position: Vector2) -> void:
	player_util.with_player(self, func(player: Node2D):
		global_position = start_position.lerp(player.global_position, percent)
		var direction_from_start = player.global_position - start_position
		var target_rotation = direction_from_start.angle() + deg_to_rad(90)
		rotation = lerp_angle(rotation, target_rotation, 1 - exp(-get_process_delta_time()))
	)


func collect() -> void:
	GameEvents.emit_experience_vial_collected(1)
	queue_free()
	
	
func disable_collision() -> void:
	collision_shape_2d.disabled = true
