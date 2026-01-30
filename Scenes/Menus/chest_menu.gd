extends Control

var chest_queue_free

@onready var contenedor = get_children()[0].get_children()[0]

func _ready() -> void:
	GlobalSignals.open_chest.connect(open_chest)
	hide()


func open_chest(chest):
	chest_queue_free=chest
	
	var item = ItemManager.get_item()
	contenedor.get_child(0).text = item.name
	contenedor.get_child(1).text = ItemManager.get_rarity(item)
	contenedor.get_child(2).texture = item.icon
	contenedor.get_child(3).text = item.description
	contenedor.get_child(4).text = ItemManager.get_stats(item)
	
	show_menu()
	GlobalSignals.emit_signal("get_item", item)

func show_menu():
	get_tree().paused = true
	$AnimationPlayer.play("pop_in")
	show()


func _on_button_pressed() -> void:
	hide()
	get_tree().paused = false
	chest_queue_free.queue_free()
