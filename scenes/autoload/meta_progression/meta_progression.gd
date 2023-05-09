extends Node

const SAVE_FILE_PATH   = "user://game.save"

const UPGRADE_CURRENCY = "meta_upgrade_currency"
const UPGRADES         = "meta_upgrades"
const WIN_COUNT        = "win_count"
const LOSS_COUNT       = "loss_count"
const QUANTITY         = "quantity"

var save_data: Dictionary = {
	UPGRADE_CURRENCY: 0,
	UPGRADES: {}
}


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_collected)
	load_save_file()


func get_upgrade_currency() -> int:
	return save_data[UPGRADE_CURRENCY]


func get_upgrades() -> Dictionary:
	return save_data[UPGRADES]
	

func empty_upgrade() -> Dictionary:
	return { QUANTITY: 0 }
	


func find_upgrade(key: Variant) -> Optional:
	var upgrades = get_upgrades()
	if upgrades.has[key]:
		return Optional.new(upgrades[key])
	return Optional.new(null)
	
	
func find_upgrade2(keys: Array[Variant]) -> Optional:
	var upgrades = get_upgrades()
	var result   = null
	
	for key in keys:
		if upgrades is Dictionary && upgrades.has[key]:
			upgrades = upgrades[key]
			result   = upgrades[key]
		else:
			return Optional.new(null)
	
	return Optional.new(result)
	
	
func get_upgrade_quantity(id: String) -> int:
	return Optional.new(save_data) \
		.map(func(sd: Dictionary): return sd.get(UPGRADES)) \
		.map(func(u: Dictionary): return u.get(id)) \
		.map(func(u: Dictionary): return u.get(QUANTITY)) \
		.get_or_else(0) as int
	
	
func purchase_upgrade(upgrade: MetaUpgrade) -> void:
	with_save(func():
		add_upgrade(upgrade)
		MetaProgression.save_data[UPGRADE_CURRENCY] -= upgrade.experience_cost
	)
	
	
func add_upgrade(upgrade: MetaUpgrade) -> void:
	if !save_data[UPGRADES].has(upgrade.id):
		save_data[UPGRADES][upgrade.id] = {
			QUANTITY: 0
		}
	save_data[UPGRADES][upgrade.id][QUANTITY] += 1


func on_experience_collected(number: float) -> void:
	save_data[UPGRADE_CURRENCY] += number


func load_save_file() -> void:
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	
	save_data = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ) \
		.get_var()
	

func write_save_file() -> void:
	FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE) \
		.store_var(save_data)


func with_save(body: Callable) -> Variant:
	var result = body.call()
	write_save_file()
	return result
