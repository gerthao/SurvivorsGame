extends Node2D
class_name DeathComponent

const entities_layer_provider = preload("res://utility/providers/entities_layer_provider.gd")

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var streams: Array[AudioStream] = []

@onready var death_audio_component = $DeathAudioComponent as RandomAudioStreamPlayer2DComponent


func _ready():
	death_audio_component.streams = streams
	health_component.died.connect(on_died)


func on_died() -> void:
	$GPUParticles2D.texture = sprite.texture
	var maybe_owner = Optional.new(owner).filter(func(o): return o is Node2D)
	var maybe_entities_layer = entities_layer_provider.get_entities_layer(self)
	Optional.for_all_yield([maybe_owner, maybe_entities_layer]).call(func(o: Node2D, el: Node2D):
		get_parent().remove_child(self)
		el.add_child(self)

		global_position = o.global_position
		$AnimationPlayer.play("default")
		death_audio_component.play_random()
	)
