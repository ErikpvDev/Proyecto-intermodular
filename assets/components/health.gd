extends Node
class_name Health

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted

@export var max_health: int = 3 : set = set_max_health, get = get_max_health

@onready var health: int = max_health : set= set_health, get = get_health

func set_max_health(value: int):
	var max_health_value = 1 if value <=0 else value
	
	if not max_health_value == max_health:
		var difference = max_health_value - max_health
		max_health = max_health_value
		max_health_changed.emit(difference)
		
		if health > max_health:
			health = max_health


func get_max_health() -> int:
	return max_health
	
func set_health(value: int):
	health=value
	
func get_health() -> int:
	return health
