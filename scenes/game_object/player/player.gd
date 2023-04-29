extends CharacterBody2D
class_name Player

@onready var damage_interval_timer: Timer          = $DamageIntervalTimer
@onready var damage_collision_area: Area2D         = $CollisionArea2D
@onready var velocity_component: VelocityComponent = $VelocityComponent as VelocityComponent
@onready var health_component: HealthComponent     = $HealthComponent as HealthComponent
@onready var health_bar: ProgressBar               = $HealthBar
@onready var visuals: Node2D                       = $Visuals
@onready var animation_player: AnimationPlayer     = $AnimationPlayer
@onready var abilities: Node                       = $Abilities

var colliding_bodies_count: int = 0
var base_speed: int             = 0

func _ready():
	base_speed = velocity_component.max_speed
	
	damage_collision_area.body_entered.connect(on_body_entered)
	damage_collision_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_bar_display()


func _process(delta):
	update_player(delta)


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)
	
	
func get_direction() -> Vector2:
	return get_movement_vector().normalized()
	
	
func update_velocity(delta, direction: Vector2) -> void:
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)


func update_sprite(direction: Vector2) -> void:
	if is_moving(direction):
		animation_player.play("move")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(direction.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	
																
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
	GameEvents.emit_player_damaged()
	update_health_bar_display()
	
	
func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if ability_upgrade is Ability:
		abilities.add_child((ability_upgrade as Ability).abilty_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = \
			base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)
