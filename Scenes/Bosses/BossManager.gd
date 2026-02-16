extends Node

@export var miniboss_paths := {
	"early": [
		"res://Scenes/Bosses/Golem.tscn",
		50
	],
	"mid01":[
		"res://Scenes/Bosses/Bullet_Hell/bullet_hell_boss.tscn",
		100
	],
	"mid02":[
		"res://Scenes/Bosses/Necromancer/Necromancer.tscn",
		100
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
			boss="mid02"
		10:
			boss="mid02"
		15:
			boss="mid02"
		20:
			boss="late"
		25: 
			boss="late"
	
	var miniboss = load(miniboss_paths[boss][0]).instantiate()
	miniboss.global_position = Vector2(1000,400)
	miniboss.get_children()[0].health=int(miniboss_paths[boss][1])
	$"../Enemies".add_child(miniboss)
