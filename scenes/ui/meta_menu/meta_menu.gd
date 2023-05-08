extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []
@onready var grid_container = $MarginContainer/GridContainer

var meta_upgrade_card_scence = preload("res://scenes/ui/meta_upgrade_card/meta_upgrade_card.tscn")


func _ready():
	for upgrade in upgrades:
		var meta_upgrade_card = meta_upgrade_card_scence.instantiate() as MetaUpgradeCard
		grid_container.add_child(meta_upgrade_card)
		meta_upgrade_card.set_upgrade(upgrade)
