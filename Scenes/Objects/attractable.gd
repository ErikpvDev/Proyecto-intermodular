extends Area2D

@export var attraction_radius: float = 50
@export var attraction_speed: float = 200
var attracted = false
@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("character")[0]

func _process(delta: float) -> void:
	var dist = position.distance_to(player.position)
	if dist < attraction_radius:
		attracted=true
	if attracted:
		var direction = (player.position-position).normalized()
		position+=direction * attraction_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		var nodo = self.name
		if (nodo == "Gold_coin"):
			if (randf_range(0,100)<90):
				GlobalSignals.emit_signal("add_gold", 1)
			else:
				GlobalSignals.emit_signal("add_gold", 2)
		elif (nodo == "Heart"):
			GlobalSignals.emit_signal("add_health", 1)
		else:
			GlobalSignals.emit_signal("add_shield", 1)
		queue_free()
