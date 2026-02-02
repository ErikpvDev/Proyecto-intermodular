extends Node

@export var miniboss_paths := {
	"early": [
		"res://Scenes/Bosses/Golem.tscn"
	],
	"mid":[
		"res://Scenes/Bosses/Bullet_Hell/bullet_hell_boss.tscn"
	]
}


func _ready() -> void:
	GlobalSignals.miniboss_spawn.connect(miniboss_spawn)

	
func miniboss_spawn():
	var miniboss = load(miniboss_paths["mid"][0]).instantiate()
	$"../Enemies".add_child(miniboss)
