extends CanvasLayer
class_name MainMenu

@onready var play_button     = %PlayButton
@onready var options_button  = %OptionsButton
@onready var quit_button     = %QuitButton
@onready var upgrades_button = %UpgradesButton

var options_scence = preload("res://scenes/ui/options_menu/options_menu.tscn")


func _ready():
	play_button.pressed.connect(on_play_pressed)
	upgrades_button.pressed.connect(on_upgrades_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	

func on_play_pressed() -> void:
	#ScreenTransition.transition()
	#await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_upgrades_pressed() -> void:
	#ScreenTransition.transition()
	#await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu/meta_menu.tscn")
	

func on_options_pressed() -> void:
	#ScreenTransition.transition()
	#await ScreenTransition.transitioned_halfway
	var options = options_scence.instantiate() as OptionsMenu
	add_child(options)
	options.back_pressed.connect(on_options_closed.bind(options))
	
	
func on_quit_pressed() -> void:
	get_tree().quit()
	
	
func on_options_closed(options: OptionsMenu) -> void:
	Callable(options.queue_free).call_deferred()
