class_name Optional
var value: Variant


func _init(given_value: Variant):
	value = given_value


func is_empty() -> bool:
	return value == null


func non_empty() -> bool:
	return value != null


func map(f: Callable) -> Optional:
	if value == null:
		return Optional.new(null)
	return Optional.new(f.call(value))


func flatten() -> Optional:
	if value is Optional:
		return Optional.new((value as Optional).value)
	return Optional.new(value)

	
func flat_map(f: Callable) -> Optional:
	if value == null:
		return Optional.new(null)
	return map(f).flatten()
	
	
func for_each(f: Callable) -> void:
	if value == null:
		return
	f.call(value)


func fold(default_value: Variant, f: Callable) -> Variant:
	if value == null:
		return default_value
	return f.call(value)


func filter(f: Callable) -> Optional:
	if value == null or not (f.call(value) as bool):
		return Optional.new(null)
	return Optional.new(value)


func contains(find_value: Variant) -> bool:
	return value == find_value


func get_or_else(default_value: Variant) -> Variant:
	if value == null:
		return default_value
	return value
	
	
func to_array() -> Array[Variant]:
	if value == null:
		return []
	return [value]


static func for_yield(values: Array[Variant], yield_call: Callable) -> Optional:
	if values.any(func(v): return v == null):
		return Optional.new(null)
		
	var result = yield_call.callv(values)
	return Optional.new(result)
	

static func for_yield_run(values: Array[Variant], yield_call: Callable) -> void:
	if values.any(func(v): return v == null):
		return

	yield_call.callv(values)
	

static func for_yield_opt(optionals: Array[Optional], yield_call: Callable) -> Optional:
	if optionals.any(func(v): return v.is_empty()):
		return Optional.new(null)

	var result = yield_call.callv(optionals.map(func(o: Optional): return o.value))
	return Optional.new(result)


static func for_yield_opt_run(optionals: Array[Optional], yield_call: Callable) -> void:
	if optionals.any(func(v): return v.is_empty()):
		return

	yield_call.callv(optionals.map(func(o: Optional): return o.value))
	
static func for_all_yield(optionals: Array[Optional]) -> Callable:
	return func(c: Callable) -> Optional:
		if optionals.any(func(v: Optional) -> bool: return v.is_empty()):
			return Optional.new(null)
		return Optional.new(c.callv(optionals.map(func(o: Optional) -> Variant: return o.value)))
		
static func of(call: Callable) -> Optional:
	return Optional.new(call.call())
	

func _to_string() -> String:
	if value == null:
		return "None"
	return "Some(%s)" % value
