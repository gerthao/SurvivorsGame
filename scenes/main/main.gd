extends Node

@export var end_screen_scene: PackedScene

@onready var player: Player = get_node("Entities/Player")

var pause_menu = preload("res://scenes/ui/pause_menu/pause_menu.tscn")


func _ready():
	player.health_component.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu.instantiate())
		get_tree().root.set_input_as_handled()
	
	
func on_player_died():
	var end_screen = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen)
	end_screen.set_defeat()
	end_screen.play_defeat()
