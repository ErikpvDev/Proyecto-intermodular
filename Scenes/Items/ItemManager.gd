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
