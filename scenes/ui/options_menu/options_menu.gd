extends CanvasLayer
class_name OptionsMenu

signal back_pressed

@onready var back_button   = %BackButton as SoundButton
@onready var window_button = %WindowButton as SoundButton
@onready var sfx_slider    = %SfxSlider
@onready var music_slider  = %MusicSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	update_display()
	back_button.pressed.connect(on_back_pressed)
	window_button.pressed.connect(on_window_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	

func update_display() -> void:
	window_button.text = get_window_button_text()
	sfx_slider.value   = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")


func get_window_button_text() -> String:
	return "Fullscreen" \
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN \
		else "Windowed"


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index  = AudioServer.get_bus_index(bus_name)
	var volumne_db = AudioServer.get_bus_volume_db(bus_index)
	
	return db_to_linear(volumne_db)
	
	
func set_bus_volumne_percent(bus_name: String, percent: float) -> void:
	var bus_index  = AudioServer.get_bus_index(bus_name)
	var volumn_db = linear_to_db(percent)
	
	AudioServer.set_bus_volume_db(bus_index, volumn_db)
	

func on_back_pressed() -> void:
	back_pressed.emit()


func on_window_pressed() -> void:
	var current_mode = DisplayServer.window_get_mode()
	
	var mode_to_select = DisplayServer.WINDOW_MODE_FULLSCREEN \
		if current_mode != DisplayServer.WINDOW_MODE_FULLSCREEN \
		else DisplayServer.WINDOW_MODE_WINDOWED
	
	DisplayServer.window_set_mode(mode_to_select)
	update_display()
	

func on_audio_slider_changed(value: float, bus_name: String) -> void:
	set_bus_volumne_percent(bus_name, value)
