extends CanvasLayer


func _ready():
	get_tree().paused = true
	$%RestartButton.pressed.connect(on_restart_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)


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

