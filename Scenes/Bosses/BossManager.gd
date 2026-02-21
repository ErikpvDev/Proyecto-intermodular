extends Node

@export var miniboss_paths := {
	"mid01":[
		"res://Scenes/Bosses/Bullet_Hell/bullet_hell_boss.tscn",
		125
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
			boss="mid01"
		15:
			boss="mid02"
		20:
			boss="mid01"
		25: 
			boss="mid02"
	
	var health_multiplier = pow(1.0 + (current_wave / 20.0), 1.2)
	var miniboss = load(miniboss_paths[boss][0]).instantiate()
	miniboss.global_position = Vector2(1000,400)
	
	var base_health = int(miniboss_paths[boss][1])
	var final_health = int(base_health*health_multiplier)
	
	miniboss.health = final_health
	$"../Enemies".add_child(miniboss)
	miniboss.setup_health(final_health)
