extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label: Label                 = %NameLabel
@onready var description_label: Label          = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar         = %ProgressBar
@onready var purchase_button: Button           = %PurchaseButton
@onready var progress_label: Label             = %ProgressLabel

var upgrade: MetaUpgrade


func _ready():
	purchase_button.pressed.connect(on_purchase)


func set_upgrade(meta_upgrade: MetaUpgrade) -> void:
	upgrade                = meta_upgrade
	name_label.text        = meta_upgrade.title
	description_label.text = meta_upgrade.description
	update_progress()


func select_card() -> void:
	animation_player.play("selected")


func update_progress() -> void:
	if upgrade == null:
		return
		
	var currency             = MetaProgression.get_upgrade_currency()
	var percent              = currency / upgrade.experience_cost
	percent                  = min(percent, 1)
	progress_bar.value       = percent
	purchase_button.disabled = percent < 1
	progress_label.text      = "%s/%s" % [currency, upgrade.experience_cost]
	
	
func on_purchase():
	Optional.new(upgrade).for_each(func(u): 
		MetaProgression.purchase_upgrade(u)
		get_tree().call_group("meta_upgrade_card", "update_progress")
		select_card()
	)
