extends Node

@export var miniboss_interval = 5

@export var miniboss_paths := {
	"early": [
		"res://Scenes/Bosses/Golem.tscn"
	]
}


func _ready() -> void:
	GlobalSignals.miniboss_spawn.connect(miniboss_spawn)
	
	
func miniboss_spawn():
	var miniboss = load(miniboss_paths["early"][0]).instantiate()
	$"../Enemies".add_child(miniboss)
	
	
	
	
	
	
	
	
	
	
	
