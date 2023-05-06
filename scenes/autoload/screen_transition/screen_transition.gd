extends CanvasLayer

signal transitioned_halfway

@onready var animation_player = $AnimationPlayer as AnimationPlayer

func transition() -> void:
	animation_player.play("transition_in")
	await animation_player.animation_finished
	transitioned_halfway.emit()
	animation_player.play_backwards("transition_in")

func emit_transitioned_halfway():
	transitioned_halfway.emit()


func with_transition(task: Callable) -> void:
	animation_player.queue("transition_in")
	await transitioned_halfway
	task.call()
	animation_player.queue("transition_out")
	
