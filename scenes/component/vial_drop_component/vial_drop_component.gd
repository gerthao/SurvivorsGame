extends Node
class_name VialDropComponent

@export_range(0, 1) var drop_percent: float = .5
@export var health_component: HealthComponent
@export var vial_scene: PackedScene

const entities_layer_provider = preload("res://utility/providers/entities_layer_provider.gd")


func _ready():
	health_component.died.connect(on_died)


func on_died() -> void:
	if randf() > drop_percent:
		return
	
	var maybe_owner  = Optional.new(owner).filter(func(o): return o is Node2D)
	var maybe_vial_scence = Optional.new(vial_scene)
	var maybe_entities_layer = entities_layer_provider.get_entities_layer(self)
	
	Optional.for_all_yield(
		[maybe_owner, maybe_vial_scence, maybe_entities_layer]
	).call(spawn_vial)


func spawn_vial(given_owner: Node2D, given_vial_scence: PackedScene, entities_layer: Node2D) -> void:
	var spawn_position = given_owner.global_position
	var vial = given_vial_scence.instantiate() as Node2D
	entities_layer.get_parent().add_child(vial)
	vial.global_position = spawn_position
	
	

