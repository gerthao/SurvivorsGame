extends CharacterBody2D

@onready var health_component: HealthComponent     = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var visuals: Node2D                       = $Visuals
@onready var sprite: Sprite2D                      = $Visuals/Sprite2D
@onready var animation_player: AnimationPlayer     = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D  = $CollisionShape2D

var is_moving: bool = false


func _process(delta):
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)
	update_sprite(velocity_component.velocity)
	

func update_sprite(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		animation_player.play("RESET")
		return 
		
	animation_player.play("move")
	visuals.scale = Vector2(sign(direction.x), 1)


func set_is_moving(moving: bool) -> void:
	is_moving = moving
	
	
func get_collision_size() -> int:
	return (collision_shape_2d.shape as CircleShape2D).radius * 4
