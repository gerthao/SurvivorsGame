extends PanelContainer
class_name AbilityUpgradeCard

signal selected 

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var disabled: bool = false


func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	name_label.text        = upgrade.name
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent) -> void:
	if disabled: return
	
	if event.is_action_pressed("left_click"):
		select_card()


func play_in(delay: float = 0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")


func select_card() -> void:
	disabled = true
	animation_player.play("selected")

	for card in get_tree().get_nodes_in_group("upgrade_card"):
		if card == self:
			continue
		(card as AbilityUpgradeCard).play_discard()
	
	await animation_player.animation_finished
	selected.emit()


func play_discard() -> void:
	animation_player.play("discard")


func on_mouse_entered() -> void:
	if disabled: return
		
	animation_player.play("hover_in")


func on_mouse_exited() -> void:
	if disabled: return
	
	animation_player.queue("hover_out")
