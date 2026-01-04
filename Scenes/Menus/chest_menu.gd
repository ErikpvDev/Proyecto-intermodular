extends Control

var chest_queue_free

func _ready() -> void:
	GlobalSignals.open_chest.connect(open_chest)
	hide()


func open_chest(chest):
	chest_queue_free=chest
	show_menu()

func show_menu():
	get_tree().paused = true
	$AnimationPlayer.play("pop_in")
	show()


func _on_button_pressed() -> void:
	hide()
	get_tree().paused = false
	chest_queue_free.queue_free()
