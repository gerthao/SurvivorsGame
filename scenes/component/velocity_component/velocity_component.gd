extends Node
class_name VelocityComponent

const player_util = preload("res://utility/player_utilty/player_utility.gd")

@export var max_speed: int      = 40
@export var acceleration: float = 5.

var velocity = Vector2.ZERO


func accelerate_to_player() -> void:
	var get_node2d_owner = Optional.new(owner).filter(func(o): return o is Node2D)
	var get_player       = player_util.find_player(self)
	var result: Optional = Optional.for_all_yield([get_node2d_owner, get_player]).call(get_direction_towards_player)
	
	result.for_each(accelerate_in_direction)
	
func get_direction_towards_player(owner_node2d: Node2D, player: Node2D) -> Vector2:
	return (player.global_position - owner_node2d.global_position).normalized()


func accelerate_in_direction(direction: Vector2) -> void:
	var desired_velocity = direction * max_speed
	velocity             = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	
	
func decelerate() -> void:
	accelerate_in_direction(Vector2.ZERO)	 


func move(character_body: CharacterBody2D) -> void:
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
