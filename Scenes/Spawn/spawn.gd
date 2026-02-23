extends Node2D

@onready var current_wave=1
var base_elite_chance = 0.02
var elite_prob_percent
@export var exp_growth=1.12
@export var exp_elite_growth=3
@export var hp_growth=1.10
@export var hp_elite_growth=1.13
@export var base_hp=10
@export var base_elite_hp=50
@onready var between_waves=3
@onready var wave_text = $"../UI/Wave/Wave/Label"

var vase_count
var vase_growth
var rare_vase_prob

var base_gold_vase=10
var base_exp_vase=8

var gold_vase_growth = 1.05
var exp_vase_growth = 1.04

@onready var vase = preload("res://Scenes/Objects/vase.tscn")
@onready var interactable_scene= $"../Interactables"

var spawn_time = 1

var total_time: float = 0.0
var timer_active : bool = true


@onready var enemy_dict = {
	1: [6, 1.1],
	2: [12,1.1],
	3: [18,1.1],
	4: [24,1.1],
	5: [1,1.7],
	6: [36,1.54],
	7: [42,1.65],
	8: [50,1.77],
	9: [58,1.88],
	10: [1,2.0], 
	11: [75,2.12],
	12: [82,2.24],
	13: [90,2.37],
	14: [100,2.5],
	15: [1,2.63], 
	16: [125,2.76],
	17: [138,2.89],
	18: [150,3.02],
	19: [165,3.16],
	20: [1,3.3], 
	21: [200,3.44],
	22: [220,3.58],
	23: [240,3.72],
	24: [265,3.86],
	25: [1,4.0],
}

@onready var enemy=preload("res://Scenes/Enemies/enemigo.tscn")
@onready var dead_enemies=0
@onready var camera = $"../Character/Camera2D"

var elite_multiplier = {}
@export var time_between_waves: float = 3

signal between_waves_screen_timer

func _ready():
	update_wave()
	
func _process(delta: float) -> void:
	if timer_active:
		total_time += delta

func enemy_death():
	dead_enemies+=1
	if dead_enemies==enemy_dict[current_wave][0]:
		dead_enemies=0
		if current_wave == 25:
			timer_active=false
			MusicManager.stop()
			VfxManager.play_sound("victory")
			GlobalSignals.emit_signal("victory_menu",total_time)
			return
		await get_tree().create_timer(time_between_waves,false).timeout
		current_wave+=1
		update_wave()
	

func get_valid_spawnpoint(cam: Camera2D, tilemap_layer: TileMapLayer, margin: float = 32.0):
	
	var used_rect_i: Rect2i = tilemap_layer.get_used_rect()
	var tile_size = tilemap_layer.tile_set.tile_size
	var local_spawn_rect = Rect2(
		Vector2(used_rect_i.position) * Vector2(tile_size), 
		Vector2(used_rect_i.size) * Vector2(tile_size)
	)
	
	var world_spawn_rect: Rect2 = tilemap_layer.get_global_transform() * local_spawn_rect
	world_spawn_rect = world_spawn_rect.grow(-margin)
	
	var cam_center = cam.get_screen_center_position()
	var cam_size = cam.get_viewport_rect().size / cam.zoom
	var cam_top_left = cam_center - (cam_size / 2)
	
	var camera_rect = Rect2(cam_top_left, cam_size).grow(margin)
	
	# Zona Arriba: Todo lo que está arriba de la cámara, dentro del mapa
	var top_rect = Rect2(
		world_spawn_rect.position.x,
		world_spawn_rect.position.y,
		world_spawn_rect.size.x,
		camera_rect.position.y - world_spawn_rect.position.y
	)
	
	# Zona Abajo: Todo lo que está abajo de la cámara, dentro del mapa
	var bottom_rect = Rect2(
		world_spawn_rect.position.x,
		camera_rect.end.y,
		world_spawn_rect.size.x,
		world_spawn_rect.end.y - camera_rect.end.y
	)
	
	# Zona Izquierda: Izquierda de la cámara, acotada a la altura de la cámara
	var left_rect = Rect2(
		world_spawn_rect.position.x,
		camera_rect.position.y,
		camera_rect.position.x - world_spawn_rect.position.x,
		camera_rect.size.y
	)
	
	# Zona Derecha: Derecha de la cámara, acotada a la altura de la cámara
	var right_rect = Rect2(
		camera_rect.end.x,
		camera_rect.position.y,
		world_spawn_rect.end.x - camera_rect.end.x,
		camera_rect.size.y
	)

	var valid_zones = []
	
	if top_rect.size.x > 0 and top_rect.size.y > 0:
		valid_zones.append(top_rect)
	if bottom_rect.size.x > 0 and bottom_rect.size.y > 0:
		valid_zones.append(bottom_rect)
	if left_rect.size.x > 0 and left_rect.size.y > 0:
		valid_zones.append(left_rect)
	if right_rect.size.x > 0 and right_rect.size.y > 0:
		valid_zones.append(right_rect)
		
	if valid_zones.is_empty():
		return Vector2.ZERO 

	for i in range(20):
		var chosen_zone: Rect2 = valid_zones.pick_random()
		
		var random_point = Vector2(
			randf_range(chosen_zone.position.x, chosen_zone.end.x),
			randf_range(chosen_zone.position.y, chosen_zone.end.y)
		)
		
		var local_pos = tilemap_layer.to_local(random_point)
		var map_coords = tilemap_layer.local_to_map(local_pos)
		
		var tile_data = tilemap_layer.get_cell_tile_data(map_coords)
		
		if tile_data != null:
			
			return random_point
			
	return Vector2.ZERO


func spawn_enemies():
	#Spawn the enemies in the valid spawnpoints
	for i in range(enemy_dict[current_wave][0]):
		if randf_range(0,100)<elite_prob_percent:
			var e=enemy.instantiate()
			e.scale = e.scale*1.3
			e.position=get_valid_spawnpoint(camera,$"../TileMapLayer")
			e.elite=true
			e.exp_value=int(e.exp_value*pow(exp_growth,current_wave-1))*8
			e.get_children()[0].health=int(base_elite_hp*pow(hp_elite_growth,current_wave-1))
			$"../Enemies".add_child(e)
			await get_tree().create_timer(spawn_time,false).timeout
		else:
			var e=enemy.instantiate()
			
			e.position=get_valid_spawnpoint(camera,$"../TileMapLayer")
			e.elite=false
			e.exp_value=int(e.exp_value*pow(exp_growth,current_wave-1))
			e.get_children()[0].health=int(base_hp*pow(hp_growth,current_wave-1))
			$"../Enemies".add_child(e)
			#Delay entre spawn de enemigos
			await get_tree().create_timer(spawn_time,false).timeout

func spawn_vase():
	for i in range(8):
		if randi_range(0,100)<rare_vase_prob:
			var v = vase.instantiate()
			v.position=get_valid_spawnpoint(camera,$"../TileMapLayer")
			interactable_scene.add_child(v)
		else:
			var v = vase.instantiate()
			v.position=get_valid_spawnpoint(camera,$"../TileMapLayer")
			interactable_scene.add_child(v)
			

func update_wave():
	var prob
	for rondas in enemy_dict:
		prob = base_elite_chance * enemy_dict[rondas][1]
		elite_prob_percent = snapped(prob * 100, 2)
	
	emit_signal("between_waves_screen_timer")
	
	#Vase calculation
	spawn_time*=0.8
	vase_count=1+floor((current_wave-1)/5)
	vase_count= min(vase_count,6)
	rare_vase_prob= clamp(5+(current_wave-1)*0.5,5,25)
	
	
	await get_tree().create_timer(between_waves,false).timeout
	wave_text.text = "WAVE "+str(current_wave)
	if current_wave % 5 != 0:
		spawn_enemies()
	else:
		GlobalSignals.emit_signal("miniboss_spawn",current_wave)
	spawn_vase()
