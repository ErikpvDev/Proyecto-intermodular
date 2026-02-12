extends Node

@export var max_health: int 
@onready var health: int

signal health_changed(new_health)
signal max_health_changed(new_health,prev_max_health)

func _ready() -> void:
	GlobalSignals.add_health.connect(add_health)
	GlobalSignals.add_max_health.connect(add_max_health)

func take_damage(damage:int) ->void:
	if health>0:
		health-=damage
		emit_signal("health_changed",health)

func add_max_health(amount:int) -> void:
	if max_health < 10:
		var prev_max_health=max_health
		max_health+=amount
		emit_signal("max_health_changed",max_health,prev_max_health)
		GlobalSignals.emit_signal("update_heart_display")

func add_health(amount:int)->void:
	if amount<=max_health-health:
		health+=amount
	emit_signal("health_changed",health)
	GlobalSignals.emit_signal("update_heart_display")
