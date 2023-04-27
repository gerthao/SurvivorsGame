extends CharacterBody2D

@onready var health_component: HealthComponent     = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var visuals: Node2D                       = $Visuals
@onready var sprite: Sprite2D                      = $Visuals/Sprite2D
@onready var animation_player: AnimationPlayer     = $AnimationPlayer

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
