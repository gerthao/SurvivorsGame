extends Node
class_name AxeAbilityController

const provider = preload("res://utility/providers/node_provider.gd")
var damage     = 10

@export var axe_ability_scene: PackedScene


func _ready():
	$Timer.timeout.connect(on_timeout)
	

func on_timeout():
	var player     = provider.find_node_in_group(self, "player")
	var foreground = provider.find_node_in_group(self, "foreground")
	
	Optional.for_all_yield([player, foreground]).call(func(p: Node2D, fg: Node):
		var axe = axe_ability_scene.instantiate() as AxeAbility
		fg.add_child(axe)
		axe.global_position = p.global_position
		axe.hitbox_component.damage = damage
	)
