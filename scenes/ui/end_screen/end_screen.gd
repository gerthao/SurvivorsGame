extends CanvasLayer
class_name EndScreen

@onready var victory_stream_player = $VictoryStreamPlayer as RandomAudioStreamPlayerComponent
@onready var defeat_stream_player  = $DefeatStreamPlayer as RandomAudioStreamPlayerComponent
@onready var panel_container       = $%PanelContainer
@onready var title_label           = %TitleLabel
@onready var description_label     = %DescriptionLabel
@onready var restart_button        = %RestartButton
@onready var quit_button           = %QuitButton


func _ready():
	initialize_panel()
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_pressed)
	quit_button.pressed.connect(on_quit_pressed)


func initialize_panel() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_BACK)


func set_defeat() -> void:
	title_label.text       = "Defeat"
	description_label.text = "You lost!"


func set_victory() -> void:
	title_label.text       = "Victory"
	description_label.text = "You won!"
	
	
func play_victory() -> void:
	victory_stream_player.play_random()
	

func play_defeat() -> void:
	defeat_stream_player.play_random()


func on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	

func on_quit_pressed() -> void:
	get_tree().quit()

