extends CanvasLayer


func _ready():
	GameEvents.player_damaged.connect(on_player_damage)


func _process(delta):
	pass


func on_player_damage() -> void:
	$AnimationPlayer.play("hit")
