extends Node

@export var end_screen_scene: PackedScene

@onready var player: Player = get_node("Entities/Player")


func _ready():
	player.health_component.died.connect(on_player_died)
	
	
func on_player_died():
	var end_screen = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen)
	end_screen.set_defeat()
	end_screen.play_defeat()
	
