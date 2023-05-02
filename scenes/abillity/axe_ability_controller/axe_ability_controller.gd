extends Node
class_name AxeAbilityController

const provider = preload("res://utility/providers/node_provider.gd")

var base_damage                = 8
var additional_damage_percent = 1

@export var axe_ability_scene: PackedScene
@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func get_damage():
	return base_damage * additional_damage_percent


func on_timeout():
	var player     = provider.find_node_in_group(self, "player")
	var foreground = provider.find_node_in_group(self, "foreground")
	
	Optional.for_all_yield([player, foreground]).call(func(p: Node2D, fg: Node):
		var axe = axe_ability_scene.instantiate() as AxeAbility
		fg.add_child(axe)
		axe.global_position         = p.global_position
		axe.hitbox_component.damage = get_damage()
	)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == "axe_damage":
		additional_damage_percent = 1 + (current_upgrades["axe_damage"]["quantity"] * .1)
