extends CharacterBody2D
class_name BasicEnemy

const player_util = preload("res://utility/player_utilty/player_utility.gd")
const BASE_SPEED = 40
@onready var health_component: HealthComponent = $HealthComponent


func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * BASE_SPEED
	move_and_slide()


func get_direction_to_player() -> Vector2:
	return player_util.find_player(self).fold(Vector2.ZERO, func(p): 
		return (p.global_position - global_position).normalized()
	)
