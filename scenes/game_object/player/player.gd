extends CharacterBody2D
class_name Player

const BASE_SPEED             = 125
const ACCELERATION_SMOOTHING = 25

@onready var damage_interval_timer: Timer      = $DamageIntervalTimer
@onready var damage_collision_area: Area2D     = $CollisionArea2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar           = $HealthBar
@onready var sprite: Sprite2D                  = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var colliding_bodies_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	damage_collision_area.body_entered.connect(on_body_entered)
	damage_collision_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timeout)
	health_component.health_changed.connect(on_health_changed)
	update_health_bar_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_player(delta)
	move_and_slide()


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)
	
	
func get_direction() -> Vector2:
	return get_movement_vector().normalized()
	
	
func update_velocity(delta, direction: Vector2) -> void:
	var target_velocity = get_direction() * BASE_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))


func update_sprite(direction: Vector2) -> void:
	if is_moving(direction):
		sprite.flip_h = direction.x < 0
		animation_player.play("move")
	
																
func update_player(delta) -> void:
	var direction = get_direction()
	update_velocity(delta, direction)
	update_sprite(direction)
	

func is_moving(direction: Vector2) -> bool:
	return direction.x != 0 || direction.y != 0


func check_deal_damage() -> void:
	if colliding_bodies_count == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.take_damage(1)
	damage_interval_timer.start()
	

func update_health_bar_display() -> void:
	health_bar.value = health_component.get_health_percent()
	
	
func on_body_entered(other_body: Node2D) -> void:
	colliding_bodies_count += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D) -> void:
	colliding_bodies_count -= 1


func on_damage_interval_timeout() -> void:
	check_deal_damage()


func on_health_changed() -> void:
	update_health_bar_display()
	
	
