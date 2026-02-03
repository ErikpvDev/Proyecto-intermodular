extends Node

# Probabilidades para cada rareza de objeto
const CHANCE_COMMON = 0.75      # 75%
const CHANCE_RARE = 0.20        # 20%
const CHANCE_LEGENDARY = 0.05   # 5%

# Arrays para los objetos segun su calidad
@export var common_items: Array[ItemData] = []
@export var rare_items: Array[ItemData] = []
@export var legendary_items: Array[ItemData] = []

func _ready():
	load_from_folder("res://Scenes/Items/common/", common_items)
	load_from_folder("res://Scenes/Items/rare/", rare_items)
	load_from_folder("res://Scenes/Items/legendary/", legendary_items)
	
	#print("Items cargados: %d Comunes, %d Raros, %d Legendarios" % [common_items.size(), rare_items.size(), legendary_items.size()])

func get_item():
	var roll = randf()
	
	if roll > 1-CHANCE_COMMON :
		return common_items.pick_random()
	elif roll > 1-CHANCE_COMMON-CHANCE_RARE:
		return rare_items.pick_random()
	else:
		return legendary_items.pick_random()
	
func get_different_items(amount: int):
	var item_array = []
	var item_try
	while (item_array.size() < amount):
		item_try = get_item()
		if (item_try not in item_array):
			item_array.append(item_try)
	return item_array

# Función para leer de carpetas
func load_from_folder(path: String, target_array: Array[ItemData]):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# En exportación los archivos se llaman .remap, hay que limpiar el nombre
			if file_name.ends_with(".tres") or file_name.ends_with(".tres.remap"):
				var clean_path = path + file_name.replace(".remap", "")
				var item = load(clean_path)
				if item is ItemData:
					target_array.append(item)
			file_name = dir.get_next()

func get_stats(item: ItemData):
	var stats = ""
	if (item.damage_bonus>0):
		stats += "+%d damage " % item.damage_bonus
	if (item.attack_speed_bonus>0):
		stats += "+%d%% attack speed " % (item.attack_speed_bonus*100)
	if (item.crit_chance_bonus>0):
		stats += "+%d%% crit chance " % (item.crit_chance_bonus*100)
	if (item.move_speed_bonus>0):
		stats += "+%d%% movement speed " % (item.move_speed_bonus*100)
	if (item.dodge_chance_bonus>0):
		stats += "+%d%% dodge chance " % (item.dodge_chance_bonus*100)
	if (item.max_hp_bonus>0):
		stats += "+%d max health " % item.max_hp_bonus
	if (item.shield_bonus>0):
		stats += "+%d shield " % item.shield_bonus
	if (item.damage_multiplier>1):
		stats += "%.1fx damage " % item.damage_multiplier
	if (item.projectile_size_multiplier>1):
		stats += "%.1fx projectile size " % item.projectile_size_multiplier
	return stats

func get_rarity(item: ItemData):
	var rarity
	
	match item.rarity:
		0:
			rarity = "[color=#b0b0b0]Common[/color]\n"
		1:
			rarity = "[color=#4488ff]Rare[/color]\n"
		2:
			rarity = "[color=#ffaa00]Legendary[/color]\n"
	return rarity
	
func get_price(item: ItemData):
	var price
	
	match item.rarity:
		0:
			price = 15
		1:
			price = 40
		2:
			price = 80
	return price
