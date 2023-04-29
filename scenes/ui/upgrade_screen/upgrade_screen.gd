extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scence: PackedScene

@onready var card_container: HBoxContainer     = $"MarginContainer/CardContainer"
@onready var animation_player: AnimationPlayer = $"AnimationPlayer"


func _ready():
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]) -> void:
	var delay = 0
	for upgrade in upgrades:
		handle_upgrade(upgrade, delay)
		delay += .2

func handle_upgrade(upgrade: AbilityUpgrade, delay: float = 0) -> void:
	var card = upgrade_card_scence.instantiate() as AbilityUpgradeCard
	
	card_container.add_child(card)
	card.set_ability_upgrade(upgrade)
	card.play_in(delay)

	card.selected.connect(on_upgrade_selected.bind(upgrade))
	

func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	upgrade_selected.emit(upgrade)
	animation_player.play("out")
	await animation_player.animation_finished
	get_tree().paused = false
	queue_free()
