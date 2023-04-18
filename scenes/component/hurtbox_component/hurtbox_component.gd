extends Area2D
class_name HurtboxComponent


@export var health_component: HealthComponent


func _ready():
	area_entered.connect(on_area_entered)
	

func on_area_entered(other_area: Area2D) -> void:
	var maybe_health_component  = Optional.new(health_component)
	var maybe_area              = Optional.new(other_area).filter(func(a): return a is HitboxComponent)
	var update_health_component = Optional.for_all_yield([maybe_health_component, maybe_area])
	
	update_health_component.call(func(hc: HealthComponent, a: HitboxComponent):
		hc.take_damage(a.damage)
	)
