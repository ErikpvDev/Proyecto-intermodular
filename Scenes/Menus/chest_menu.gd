extends Control

signal close_menu

func _ready() -> void:
	hide()

func show_menu():
	get_tree().paused = true
	$AnimationPlayer.play("pop_in")
	show()


func _on_button_pressed() -> void:
	emit_signal("close_menu")
	hide()
