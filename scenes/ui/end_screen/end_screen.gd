extends CanvasLayer

@onready var panel_container = $%PanelContainer

func _ready():
	initialize_panel()
	get_tree().paused = true
	$%RestartButton.pressed.connect(on_restart_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)


func initialize_panel() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_BACK)



func set_defeat() -> void:
	$%TitleLabel.text      = "Defeat"
	$%DescriptionLabel.text = "You lost!"


func set_victory() -> void:
	$%TitleLabel.text = "Victory"
	$%DescriptionLabel.text = "You won!"


func on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	

func on_quit_pressed() -> void:
	get_tree().quit()

