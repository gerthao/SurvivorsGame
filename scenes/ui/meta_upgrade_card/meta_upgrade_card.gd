extends PanelContainer
class_name MetaUpgradeCard


@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	gui_input.connect(on_gui_input)


func set_upgrade(upgrade: AbilityUpgrade) -> void:
	name_label.text        = upgrade.name
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		select_card()


func select_card() -> void:
	animation_player.play("selected")
	
	await animation_player.animation_finished
