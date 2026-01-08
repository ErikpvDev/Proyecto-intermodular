extends Node

@export var miniboss_interval = 5

@export var miniboss_paths := {
	"early": [
		
	]
}

func _ready() -> void:
	GlobalSignals.miniboss_spawn.connect(miniboss_spawn)
	
	
func miniboss_spawn():
	
	
	
	
	
	
