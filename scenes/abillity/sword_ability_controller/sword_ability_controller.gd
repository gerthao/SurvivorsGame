extends Node

@export var sword_ability: PackedScene

const player_util = preload("res://utility/player_utilty/player_utility.gd")
const foreground_provider = preload("res://utility/providers/foreground_provider.gd")

const BASE_RANGE = 150
const SWORD_RATE_ID = "sword_rate"

var damage = 5
var base_wait_time: float

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	
func on_timer_timeout() -> void:
	player_util.find_player(self).for_each(func(p: Node2D):
		foreground_provider.get_foreground(self).for_each(func(fg: Node2D):
			var enemies = get_enemies_in_range(p)
			if enemies.size() > 0:
				spawn_sword_at_enemy(fg, enemies[0])
		)
	)
	

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id != SWORD_RATE_ID:
		return
	
	var percentage_reduction = current_upgrades[SWORD_RATE_ID]["quantity"] * .1
	apply_cooldown_reduction($Timer, base_wait_time, percentage_reduction)
	print($Timer.wait_time)


func apply_cooldown_reduction(timer: Timer, base_cooldown: float, percentage_reduction: float) -> void:
	timer.wait_time = base_cooldown * (1 - percentage_reduction)
	timer.start()

func get_enemies_in_range(player: Node2D) -> Array:
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func (n: Node2D):
		return n.global_position.distance_squared_to(player.global_position) < pow(BASE_RANGE, 2)
	)
	enemies.sort_custom(func (a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		
		return a_distance < b_distance
	)
	return enemies

func spawn_sword_at_enemy(foreground: Node2D, enemy: Node2D) -> void:
	var sword = sword_ability.instantiate() as SwordAbility
	foreground.add_child(sword)
	
	sword.hitbox_component.damage = damage
	sword.global_position = enemy.global_position
	sword.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemy.global_position - sword.global_position
	sword.rotation = enemy_direction.angle()
