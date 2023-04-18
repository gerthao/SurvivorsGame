extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)
	
	
func on_level_up(current_level: int) -> void:
	Optional.new(upgrade_pool.pick_random()).for_each(func(upgrade: AbilityUpgrade):
		var upgrade_screen = upgrade_screen_scene.instantiate()
		add_child(upgrade_screen)
		upgrade_screen.set_ability_upgrades([upgrade] as Array[AbilityUpgrade])
		upgrade_screen.upgrade_selected.connect(on_upgrade_selected)
	)
	
	
func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
