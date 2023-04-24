extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

var floating_text_scence: PackedScene = preload("res://scenes/ui/floating_text/floating_text.tscn")
var foreground_provider = preload("res://utility/providers/foreground_provider.gd")


func _ready():
	area_entered.connect(on_area_entered)
	

func on_area_entered(other_area: Area2D) -> void:
	var maybe_health_component  = Optional.new(health_component)
	var maybe_hitbox_component  = Optional.new(other_area).filter(func(a): return a is HitboxComponent)
	var update_health_component = Optional.for_all_yield([maybe_health_component, maybe_hitbox_component, foreground_provider.get_foreground(self)])
	
	update_health_component.call(func(health_comp: HealthComponent, hit_comp: HitboxComponent, foreground: Node):
		health_comp.take_damage(hit_comp.damage)
		
		var floating_text = floating_text_scence.instantiate() as Node2D
		foreground.add_child(floating_text)
		
		floating_text.global_position = global_position + Vector2.UP * 16
		
		var format_string = "%0.1f"
		if round(hit_comp.damage) == hit_comp.damage:
			format_string = "%0.0f"
		
		floating_text.start(format_string % hit_comp.damage)
	)
