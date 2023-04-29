extends Node

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var upgrade_pool: WeightedTable
var current_upgrades = {}

var upgrade_axe_skill    = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage   = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate   = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")


func _ready():
	initialize_upgrade_pool()
	experience_manager.level_up.connect(on_level_up)


func initialize_upgrade_pool() -> void:
	upgrade_pool = WeightedTable.new() \
		.add_item(upgrade_axe_skill, 10) \
		.add_item(upgrade_sword_rate, 10) \
		.add_item(upgrade_sword_damage, 10) \
		.add_item(upgrade_player_speed, 5)
		
		
func update_upgrade_pool(chosen_upgrade: AbilityUpgrade) -> void:
	if chosen_upgrade.id == upgrade_axe_skill.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade = current_upgrades.has(upgrade.id)
	
	if !has_upgrade:
		current_upgrades[upgrade.id] = { "resource": upgrade, "quantity": 1 }
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
		
	if upgrade.max_quantity > 0 and current_upgrades[upgrade.id]["quantity"] == upgrade.max_quantity:
		upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)


func pick_upgrades(count: int) -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in count:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
					
		upgrade_pool.pick_item(chosen_upgrades).for_each(func (au: AbilityUpgrade): chosen_upgrades.append(au))
	
	return chosen_upgrades

	
func on_level_up(current_level: int) -> void:
	var upgrade_screen = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen)
	upgrade_screen.set_ability_upgrades(pick_upgrades(2) as Array[AbilityUpgrade])
	upgrade_screen.upgrade_selected.connect(on_upgrade_selected)

	
func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
