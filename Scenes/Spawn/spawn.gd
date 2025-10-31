extends Node2D

@onready var current_wave=1
var base_elite_chance = 0.02
var elite_prob_percent
@export var exp_growth=1.15
@export var hp_growth=1.10
@export var hp_elite_growth=5
@export var base_hp=10
@onready var between_waves=5

@onready var enemy_dict = {
	1: [6, 1.1],
	2: [12,1.1],
	3: [18,1.1],
	4: [24,1.1],
	5: [30,1.7],   # Primer mini-jefe
	6: [36,1.54],
	7: [42,1.65],
	8: [50,1.77],
	9: [58,1.88],
	10: [70,2.0],  # Jefe intermedio
	11: [75,2.12],
	12: [82,2.24],
	13: [90,2.37],
	14: [100,2.5],
	15: [115,2.63],  # Mini-jefe
	16: [125,2.76],
	17: [138,2.89],
	18: [150,3.02],
	19: [165,3.16],
	20: [185,3.3],  # Jefe mayor
	21: [200,3.44],
	22: [220,3.58],
	23: [240,3.72],
	24: [265,3.86],
	25: [300,4.0]   # Ronda final o jefe supremo
}

@onready var enemy=preload("res://Scenes/Enemies/enemigo.tscn")
@onready var dead_enemies=0
@onready var camera = $"../Character/Camera2D"

var elite_multiplier = {}
@export var time_between_waves: float = 1

func _ready():
	update_wave()


func enemy_death():
	dead_enemies+=1
	if dead_enemies==enemy_dict[current_wave][0]:
		dead_enemies=0
		await get_tree().create_timer(time_between_waves).timeout
		current_wave+=1
		update_wave()
	
	
func get_valid_spawnpoint(cam):
	# The viewport of the camera
	var vp = Rect2(
		cam.get_screen_center_position() - get_viewport_rect().size / 2 / cam.zoom,
		get_viewport_rect().size / cam.zoom
	)
	
	var point
	
	#Check if its a valid spawnpoint(is not in cam)
	while true:
		point = Vector2(randi_range(-480,951),randi_range(-360,615))
		if not vp.has_point(point):
			return point
			

func spawn_enemies():
	#Spawn the enemies in the valid spawnpoints
	for i in range(enemy_dict[current_wave][0]):
		if randi_range(0,100)<100:
			var e=enemy.instantiate()
			e.scale = e.scale*1.3
			e.position=get_valid_spawnpoint(camera)
			e.elite=true
			e.exp_value=60
			e.get_children()[0].health=int(base_hp*pow(hp_elite_growth,current_wave-1))
			$"../Enemies".add_child(e)
			await get_tree().create_timer(1).timeout
		else:
			var e=enemy.instantiate()
			
			e.position=get_valid_spawnpoint(camera)
			e.exp_value=int(e.exp_value*pow(exp_growth,current_wave-1))
			e.get_children()[0].health=base_hp
			e.get_children()[0].health=int(e.get_children()[0].health*pow(hp_growth,current_wave-1))
			print(e.get_children()[0].health)
			$"../Enemies".add_child(e)
			#Delay entre spawn de enemigos
			await get_tree().create_timer(1).timeout


func update_wave():
	var prob
	for rondas in enemy_dict:
		prob = base_elite_chance * enemy_dict[rondas][1]
		elite_prob_percent = snapped(prob * 100, 2)
	await get_tree().create_timer(between_waves).timeout
	spawn_enemies()
