extends Control

signal item_selected

func _ready() -> void:
	hide()
	
	
func show_menu():
	$AnimationPlayer.play("pop_in")
	show()

func _on_object_01_pressed() -> void:
	emit_signal("item_selected")


func _on_object_02_pressed() -> void:
	emit_signal("item_selected")

func _on_object_03_pressed() -> void:
	emit_signal("item_selected")
