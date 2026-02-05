extends Node

@export var miniboss_paths := {
	"early": [
		"res://Scenes/Bosses/Golem.tscn"
	],
	"mid":[
		"res://Scenes/Bosses/Bullet_Hell/bullet_hell_boss.tscn"
	]
}

var current_wave


func _ready() -> void:
	GlobalSignals.miniboss_spawn.connect(miniboss_spawn)

func miniboss_spawn(wave):
	var boss
	current_wave = wave
	match current_wave:
		5:
			boss="mid"
		10:
			boss="mid"
		15:
			boss="mid"
		20:
			boss="late"
		25: 
			boss="late"
	
	var miniboss = load(miniboss_paths[boss][0]).instantiate()
	miniboss.global_position = Vector2(1000,400)
	$"../Enemies".add_child(miniboss)
