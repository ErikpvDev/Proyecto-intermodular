extends Control

@onready var contenedores = get_children()[0].get_children()[1].get_children()
@onready var contenedor1 = contenedores[0]
@onready var contenedor2 = contenedores[1]
@onready var contenedor3 = contenedores[2]

@onready var item1
@onready var item2
@onready var item3
@onready var item_array = []

signal item_selected

func _ready() -> void:
	
	hide()	
	
func show_menu():
	get_items()
	$AnimationPlayer.play("pop_in")
	show()
	
	
func get_items():
	item_array = ItemManager.get_different_items(3)
	item1 = item_array[0]
	item2 = item_array[1]
	item3 = item_array[2]
	contenedor1.get_child(2).text = item1.name
	contenedor2.get_child(2).text = item2.name
	contenedor3.get_child(2).text = item3.name

func _on_object_01_pressed() -> void:
	emit_signal("item_selected")
	GlobalSignals.emit_signal("get_item", item1)

func _on_object_02_pressed() -> void:
	emit_signal("item_selected")
	GlobalSignals.emit_signal("get_item", item2)
	
func _on_object_03_pressed() -> void:
	emit_signal("item_selected")
	GlobalSignals.emit_signal("get_item", item3)
