extends Node2D
class_name FloatingText


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func start(text: String) -> void:
	$Label.text = text
	var tween = create_tween()
	
	tween.set_parallel()
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .3) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), .4) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_callback(queue_free)
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 1.5, .15) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_ELASTIC)
	scale_tween.tween_property(self, "scale", Vector2.ONE, .15) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", Vector2.ZERO, .4) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_CUBIC)
