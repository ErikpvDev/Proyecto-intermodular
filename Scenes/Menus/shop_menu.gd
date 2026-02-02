extends Control

@onready var contenedores = get_children()[0].get_children()[1].get_children()
@onready var contenedor1 = contenedores[0]
@onready var contenedor2 = contenedores[1]
@onready var contenedor3 = contenedores[2]

@onready var boton1 = contenedor1.get_child(2)
@onready var boton2 = contenedor2.get_child(2)
@onready var boton3 = contenedor3.get_child(2)

@onready var item1
@onready var item2
@onready var item3
@onready var item_array = []

@onready var boton_salir = get_children()[0].get_children()[2]

@onready var personaje = $"../../Level01/Character"
@onready var gold_coins = personaje.gold_coins

func _ready() -> void:
	hide()
	
func show_menu():
	gold_coins = personaje.gold_coins
	boton1.disabled = false
	boton2.disabled = false
	boton3.disabled = false
	get_items()
	$AnimationPlayer.play("pop_in")
	show()
	MenuManager.abrir_menu()
	
func get_items():
	item_array = ItemManager.get_different_items(3)
	item1 = item_array[0]
	item2 = item_array[1]
	item3 = item_array[2]
	contenedor1.get_child(0).text = item1.name
	contenedor2.get_child(0).text = item2.name
	contenedor3.get_child(0).text = item3.name
	contenedor1.get_child(1).text = ItemManager.get_rarity(item1)
	contenedor2.get_child(1).text = ItemManager.get_rarity(item2)
	contenedor3.get_child(1).text = ItemManager.get_rarity(item3)
	contenedor1.get_child(3).get_child(0).text = str(ItemManager.get_price(item1))
	contenedor2.get_child(3).get_child(0).text = str(ItemManager.get_price(item2))
	contenedor3.get_child(3).get_child(0).text = str(ItemManager.get_price(item3))
	contenedor1.get_child(4).text = item1.description
	contenedor2.get_child(4).text = item2.description
	contenedor3.get_child(4).text = item3.description
	boton1.get_child(0).texture = item1.icon
	boton2.get_child(0).texture = item2.icon
	boton3.get_child(0).texture = item3.icon
	contenedor1.get_child(5).text = ItemManager.get_stats(item1)
	contenedor2.get_child(5).text = ItemManager.get_stats(item2)
	contenedor3.get_child(5).text = ItemManager.get_stats(item3)

func _on_object1_pressed() -> void:
	var item_price = ItemManager.get_price(item1)
	if (gold_coins >= item_price):
		GlobalSignals.emit_signal("get_item", item1)
		boton1.disabled = true
		personaje.gold_coins -= item_price
		gold_coins = personaje.gold_coins
		GlobalSignals.emit_signal("update_gold")

func _on_object2_pressed() -> void:
	var item_price = ItemManager.get_price(item2)
	if (gold_coins >= item_price):
		GlobalSignals.emit_signal("get_item", item2)
		boton2.disabled = true
		personaje.gold_coins -= item_price
		gold_coins = personaje.gold_coins
		GlobalSignals.emit_signal("update_gold")

func _on_object3_pressed() -> void:
	var item_price = ItemManager.get_price(item3)
	if (gold_coins >= item_price):
		GlobalSignals.emit_signal("get_item", item3)
		boton3.disabled = true
		personaje.gold_coins -= item_price
		gold_coins = personaje.gold_coins
		GlobalSignals.emit_signal("update_gold")

func _on_button_pressed() -> void:
	MenuManager.cerrar_menu()
	GlobalSignals.emit_signal("leave_shop")
	
	
