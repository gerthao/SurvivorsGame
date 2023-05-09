extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []
@onready var upgrade_container = %UpgradeContainer
@onready var back_button = %BackButton

var meta_upgrade_card_scence = preload("res://scenes/ui/meta_upgrade_card/meta_upgrade_card.tscn")


func _ready():
	for upgrade in upgrades:
		var meta_upgrade_card = meta_upgrade_card_scence.instantiate() as MetaUpgradeCard
		upgrade_container.add_child(meta_upgrade_card)
		meta_upgrade_card.set_upgrade(upgrade)
	back_button.pressed.connect(on_back_pressed)
	
	
func on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
