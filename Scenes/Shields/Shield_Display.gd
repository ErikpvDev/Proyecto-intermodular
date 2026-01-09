extends HBoxContainer

@onready var shield = preload("res://Scenes/Shields/Shield.tscn")

func _ready() -> void:
	GlobalSignals.update_shield.connect(update_shield)

func update_shield(cant):
#	Clean all the shields
	for shield in get_children():
		shield.queue_free()
		
#	Print all the shields
	for i in range(cant):
		var s = shield.instantiate()
		add_child(s)
