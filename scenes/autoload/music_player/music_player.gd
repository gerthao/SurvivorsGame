extends AudioStreamPlayer

@onready var timer = $Timer

func _ready():
	finished.connect(on_finished)
	timer.timeout.connect(on_timeout)


func on_finished():
	timer.start()


func on_timeout():
	play()
