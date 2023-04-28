extends PanelContainer
class_name AbilityUpgradeCard

signal selected 

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel


func _ready():
	gui_input.connect(on_gui_input)


func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	name_label.text        = upgrade.name
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		selected.emit()


func play_in(delay: float = 0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")
