extends CanvasLayer


@export var arena_time_manager: Node
@onready var label: Label = $MarginContainer/Label


func _process(delta):
	Optional.new(arena_time_manager).for_each(func(atm):
		label.text = format_time(atm.get_time_elasped())
	)


func format_time(seconds: float) -> String:
	var minutes = floor(seconds / 60)
	var remaining = floor(seconds - (minutes * 60))
	
	return "%s:%02d" % [minutes, remaining]
	
