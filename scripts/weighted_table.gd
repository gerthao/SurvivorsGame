class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int          = 0


func add_item(item: Variant, weight: int) -> WeightedTable:
	items.append({ "item": item, "weight": weight })
	weight_sum += weight
	return self
	
	
func pick_item(exclude: Array = []) -> Optional:
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum               = weight_sum
	
	if exclude.size() > 0:
		adjusted_items      = []
		adjusted_weight_sum = 0
		
		for item in items:
			if item["item"] in exclude:
				continue
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]
	
	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iteration_sum = 0
	
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return Optional.new(item["item"])
	return Optional.new(null)
	
	
func remove_item(item: Variant) -> WeightedTable:
	items = items.filter(func (i): return i["item"] != item)
	weight_sum = 0
	for i in items:
		weight_sum += i["weight"]
	return self
