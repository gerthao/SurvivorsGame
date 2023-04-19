extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scence: PackedScene
@onready var card_container: HBoxContainer = $"MarginContainer/CardContainer"


func _ready():
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]) -> void:
	for upgrade in upgrades:
		handle_upgrade(upgrade)


func handle_upgrade(upgrade: AbilityUpgrade) -> void:
	var card = upgrade_card_scence.instantiate()
	card_container.add_child(card)
	card.set_ability_upgrade(upgrade)
	card.selected.connect(on_upgrade_selected.bind(upgrade))
	

func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	queue_free()
