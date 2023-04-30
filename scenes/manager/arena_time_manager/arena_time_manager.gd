extends Node
class_name ArenaTimeManager


signal difficulty_increased

const DIFFICULTY_INTERVAL = 5

@export var victory_screen_scene: PackedScene

@onready var timer: Timer = get_node("Timer")

var difficulty: float    = 0
var previous_time: float = 0


func _ready():
	timer.timeout.connect(on_timeout)
	
	
func _process(delta):
	manage_difficulty()


func next_time_target() -> float:
	return ((difficulty + 1) * DIFFICULTY_INTERVAL)
	

func manage_difficulty() -> void:
	if timer.time_left <= next_time_target():
		difficulty += 1
		difficulty_increased.emit(difficulty)


func get_time_elasped() -> float:
	return timer.wait_time - timer.time_left


func on_timeout() -> void:
	var victory_screen = victory_screen_scene.instantiate() as EndScreen
	add_child(victory_screen)
	victory_screen.set_victory()
	victory_screen.play_victory()
