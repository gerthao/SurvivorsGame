extends CharacterBody2D
class_name BasicEnemy

const player_util = preload("res://utility/player_utilty/player_utility.gd")
const BASE_SPEED = 40
@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals: Node2D                   = $Visuals
@onready var sprite: Sprite2D                  = $Visuals/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_texture = [
	preload("res://scenes/game_object/basic_enemy/basic_enemy_1.png"),
	preload("res://scenes/game_object/basic_enemy/basic_enemy_2.png")
].pick_random()


func _process(delta):
	sprite.texture = sprite_texture
	var direction = get_direction_to_player()
	update_sprite(direction)
	velocity = direction * BASE_SPEED
	move_and_slide()


func get_direction_to_player() -> Vector2:
	return player_util.find_player(self).fold(Vector2.ZERO, func(p): 
		return (p.global_position - global_position).normalized()
	)
	

func update_sprite(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		animation_player.play("RESET")
		return 
		
	var move_sign = sign(direction.x)
	animation_player.play("move")
	visuals.scale = Vector2(-sign(direction.x), 1)
