extends CanvasLayer
class_name PauseMenu

@onready var resume_button    = %ResumeButton
@onready var options_button   = %OptionsButton
@onready var main_menu_button = %MainMenuButton
@onready var panel_container  = $MarginContainer/PanelContainer
@onready var animation_player = $AnimationPlayer

var options_scence = preload("res://scenes/ui/options_menu/options_menu.tscn")
var is_closing: bool = false

func _ready():
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	resume_button.pressed.connect(on_resume_pressed)
	options_button.pressed.connect(on_options_pressed)
	main_menu_button.pressed.connect(on_main_menu_pressed)
	fade_in()
	

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()
	
	
func fade_in():
	animation_player.play("in")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_BACK)


func close():
	if is_closing:
		return
		
	is_closing = true
	
	fade_out()
	get_tree().paused = false
	queue_free()
	
	
func fade_out():
	animation_player.play_backwards("in")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_BACK)
		
	await tween.finished



func on_resume_pressed() -> void:
	close()

func on_options_pressed() -> void:
	var options = options_scence.instantiate() as OptionsMenu
	add_child(options)
	options.back_pressed.connect(on_options_closed.bind(options))
	
	
func on_main_menu_pressed() -> void:
	Callable(get_tree().change_scene_to_file) \
		.call_deferred("res://scenes/ui/main_menu/main_menu.tscn")
	get_tree().paused = false
	

func on_options_closed(options: OptionsMenu) -> void:
	Callable(options.queue_free).call_deferred()
