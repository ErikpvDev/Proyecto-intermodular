extends Node2D

@onready var current_wave=1

@onready var enemy_dict={
	1:6,
	2:12,
	3:18,
	4:24,
	5:30
}

@onready var enemy=preload("res://Scenes/Enemies/enemigo.tscn")
@onready var dead_enemies=0

func _ready():
	update_wave(current_wave)

func enemy_death():
	dead_enemies+=1
	if dead_enemies==enemy_dict[current_wave]:
		dead_enemies=0
		$BetweenWaves.start()
	
func spawn_enemies():
	for i in range(enemy_dict[current_wave]):
		var e=enemy.instantiate()
		e.position=get_child(randi_range(0,get_child_count()-1)).position
		$"../Enemies".add_child(e)
		#Delay entre spawn de enemigos
		await get_tree().create_timer(1).timeout
	
func update_wave(current_wave:int):
	match current_wave:
		1:
			print("Level one")
		2:
			print("Level two")
		3:
			print("Level three")
		4:
			print("Level four")
		5:
			print("Level five")
	spawn_enemies()

func _on_between_waves_timeout():
	current_wave+=1
	update_wave(current_wave)
