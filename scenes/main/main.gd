extends Node

@export var end_screen_scene: PackedScene

@onready var player: Player = get_node("Entities/Player")


func _ready():
	player.health_component.died.connect(on_player_died)
	
	
func on_player_died():
	var end_screen = end_screen_scene.instantiate()
	add_child(end_screen)
	end_screen.set_defeat()
	
