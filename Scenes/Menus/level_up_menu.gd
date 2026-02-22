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

signal item_selected

func _ready() -> void:
	hide()
	
func show_menu():
	MenuManager.abrir_menu()
	get_items()
	$AnimationPlayer.play("pop_in")
	show()
	
	
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
	contenedor1.get_child(3).text = item1.description
	contenedor2.get_child(3).text = item2.description
	contenedor3.get_child(3).text = item3.description
	boton1.get_child(0).texture = item1.icon
	boton2.get_child(0).texture = item2.icon
	boton3.get_child(0).texture = item3.icon
	boton1.add_theme_stylebox_override("normal", ItemManager.get_style(item1))
	boton1.add_theme_stylebox_override("hover", ItemManager.get_style(item1, true))
	boton1.add_theme_stylebox_override("pressed", ItemManager.get_style(item1))
	boton2.add_theme_stylebox_override("normal", ItemManager.get_style(item2))
	boton2.add_theme_stylebox_override("hover", ItemManager.get_style(item2, true))
	boton3.add_theme_stylebox_override("pressed", ItemManager.get_style(item3))
	boton3.add_theme_stylebox_override("normal", ItemManager.get_style(item3))
	boton3.add_theme_stylebox_override("hover", ItemManager.get_style(item3, true))
	boton3.add_theme_stylebox_override("pressed", ItemManager.get_style(item3))
	contenedor1.get_child(4).text = ItemManager.get_stats(item1)
	contenedor2.get_child(4).text = ItemManager.get_stats(item2)
	contenedor3.get_child(4).text = ItemManager.get_stats(item3)

func _input(event: InputEvent) -> void:
	if not visible:
		return 
	if event.is_action_pressed("1"):
		_on_object1_pressed()
	elif event.is_action_pressed("2"):
		_on_object2_pressed()
	elif event.is_action_pressed("3"):
		_on_object3_pressed()

func _on_object1_pressed() -> void:
	MenuManager.cerrar_menu()
	emit_signal("item_selected")
	GlobalSignals.emit_signal("get_item", item1)

func _on_object2_pressed() -> void:
	MenuManager.cerrar_menu()
	emit_signal("item_selected")
	GlobalSignals.emit_signal("get_item", item2)

func _on_object3_pressed() -> void:
	MenuManager.cerrar_menu()
	emit_signal("item_selected")
	GlobalSignals.emit_signal("get_item", item3)
