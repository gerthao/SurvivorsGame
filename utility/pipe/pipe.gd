class_name Pipe
var value: Variant

func _init(given_value):
	value = given_value
	
func pipe(actions: Array[Callable]) -> Variant:
	return actions.reduce(
		func (accum: Variant, current: Callable): return current.call(accum),
		value
	)
