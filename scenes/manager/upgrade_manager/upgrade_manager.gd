extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
		
	if upgrade.max_quantity > 0 and current_upgrades[upgrade.id]["quantity"] == upgrade.max_quantity:
		upgrade_pool = upgrade_pool.filter(func(u): return u.id != upgrade.id)


func pick_upgrades(count: int) -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade]   = []
	var filtered_upgrades: Array[AbilityUpgrade] = upgrade_pool.duplicate()
	for i in count:
		if filtered_upgrades.size() == 0:
			break
			
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func (u: AbilityUpgrade): 
			return u.id != chosen_upgrade.id)
	
	return chosen_upgrades

	
func on_level_up(current_level: int) -> void:
	var upgrade_screen = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen)
	upgrade_screen.set_ability_upgrades(pick_upgrades(2) as Array[AbilityUpgrade])
	upgrade_screen.upgrade_selected.connect(on_upgrade_selected)

	
func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
