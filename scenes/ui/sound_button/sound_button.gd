extends Button
class_name SoundButton

@onready var button_pressed_audio_component = $ButtonPressedAudioComponent as RandomAudioStreamPlayerComponent

func _ready():
	pressed.connect(on_pressed)
	

func on_pressed() -> void:
	button_pressed_audio_component.play_random()
