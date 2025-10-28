extends Node

@export var max_health: int = 5
var health: int

signal health_changed(new_health)
signal max_health_changed(new_health,prev_max_health)

func _ready() -> void:
	health=max_health
	

func take_damage(damage:int) ->void:
	if health>0:
		health-=damage
		emit_signal("health_changed",health)

func add_max_health(amount:int) -> void:
	var prev_max_health=max_health
	max_health+=amount
	emit_signal("max_health_changed",max_health,prev_max_health)

func add_health(amount:int)->void:
	health+=amount
	emit_signal("health_changed",health)
