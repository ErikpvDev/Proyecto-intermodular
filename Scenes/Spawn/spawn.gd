extends Node2D

@onready var current_wave=5
var base_elite_chance = 0.02
var elite_prob_percent
@export var exp_growth=1.15
@export var exp_elite_growth=3
@export var hp_growth=1.10
@export var hp_elite_growth=1.13
#@export var base_hp=10
@export var base_hp=1
#@export var base_elite_hp=50
@export var base_elite_hp=1
@onready var between_waves=1
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

@onready var enemy_dict = {
	1: [6, 1.1],
	2: [12,1.1],
	3: [18,1.1],
	4: [24,1.1],
	5: [1,1.7],   # Primer mini-jefe
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

signal between_waves_screen_timer

func _ready():
	update_wave()
	

func enemy_death():
	dead_enemies+=1
	if dead_enemies==enemy_dict[current_wave][0]:
		if ((current_wave) % 1 == 0):
			GlobalSignals.emit_signal("show_shop")
		dead_enemies=0
		await get_tree().create_timer(time_between_waves).timeout
		current_wave+=1
		update_wave()
	
#func get_valid_spawnpoint(cam: Camera2D, tilemap_layer: TileMapLayer, margin: float = 16.0):
	#
	## 1. OBTENER LÍMITES DEL TILEMAP (en Coordenadas del Mundo)
	#var used_rect_i: Rect2i = tilemap_layer.get_used_rect()
	#var local_pos = tilemap_layer.map_to_local(used_rect_i.position)
	#var local_size = used_rect_i.size * tilemap_layer.tile_set.tile_size
	#var local_spawn_rect = Rect2(local_pos, local_size)
	#var world_spawn_rect: Rect2 = tilemap_layer.get_global_transform() * local_spawn_rect
	#
	#
	## --- NUEVA LÍNEA ---
	## Encogemos el rectángulo de spawn por el margen que nos pasaron.
	## Si el margen es 16, se encoge 16 píxeles por la izq, der, arriba y abajo.
	#world_spawn_rect = world_spawn_rect.grow(-margin)
	## --------------------
	#
	#
	## 2. OBTENER LÍMITES DE LA CÁMARA (en Coordenadas del Mundo)
	#var camera_rect: Rect2 = cam.get_viewport().get_visible_rect().grow(margin)
	#
	#
	## 3. DEFINIR ZONAS DE SPAWN VÁLIDAS
	## (Esta lógica no cambia, pero ahora usa el 'world_spawn_rect' encogido)
	#
	## Zona de Arriba
	#var top_zone = Rect2(
		#world_spawn_rect.position.x,
		#world_spawn_rect.position.y,
		#world_spawn_rect.size.x,
		#camera_rect.position.y - world_spawn_rect.position.y
	#)
	#
	## Zona de Abajo
	#var bottom_zone = Rect2(
		#world_spawn_rect.position.x,
		#camera_rect.end.y,
		#world_spawn_rect.size.x,
		#world_spawn_rect.end.y - camera_rect.end.y
	#)
	#
	## Zona Izquierda
	#var left_zone = Rect2(
		#world_spawn_rect.position.x,
		#camera_rect.position.y,
		#camera_rect.position.x - world_spawn_rect.position.x,
		#camera_rect.size.y
	#)
	#
	## Zona Derecha
	#var right_zone = Rect2(
		#camera_rect.end.x,
		#camera_rect.position.y,
		#world_spawn_rect.end.x - camera_rect.end.x,
		#camera_rect.size.y
	#)
#
	## 4. CREAR LISTA DE ZONAS VÁLIDAS
	#var valid_zones = []
	#if top_zone.has_area():
		#valid_zones.append(top_zone)
	#if bottom_zone.has_area():
		#valid_zones.append(bottom_zone)
	#if left_zone.has_area():
		#valid_zones.append(left_zone)
	#if right_zone.has_area():
		#valid_zones.append(right_zone)
		#
	## 5. ELEGIR ZONA Y PUNTO
	#var chosen_zone: Rect2 = valid_zones.pick_random()
	#
	#var point = Vector2(
		#randf_range(chosen_zone.position.x, chosen_zone.end.x),
		#randf_range(chosen_zone.position.y, chosen_zone.end.y)
	#)
	#
	#return point
	
func get_valid_spawnpoint(cam: Camera2D, tilemap_layer: TileMapLayer, margin: float = 16.0):
	
	# 1. OBTENER LÍMITES DEL TILEMAP (Mundo)
	var used_rect_i: Rect2i = tilemap_layer.get_used_rect()
	#var local_pos = tilemap_layer.map_to_local(used_rect_i.position)
	# Nota: map_to_local devuelve el centro del tile, a veces es mejor usar position * tile_size directamente si no hay transforms raros.
	# Pero asumiendo tu lógica original funciona para el mapa, la dejamos así ajustando un poco:
	var tile_size = tilemap_layer.tile_set.tile_size
	var local_spawn_rect = Rect2(
		Vector2(used_rect_i.position) * Vector2(tile_size), 
		Vector2(used_rect_i.size) * Vector2(tile_size)
	)
	
	var world_spawn_rect: Rect2 = tilemap_layer.get_global_transform() * local_spawn_rect
	world_spawn_rect = world_spawn_rect.grow(-margin)
	
	# --- CORRECCIÓN PRINCIPAL AQUÍ ---
	# 2. OBTENER LÍMITES DE LA CÁMARA (Mundo Real)
	
	# Obtenemos el centro real en el mundo
	var cam_center = cam.get_screen_center_position()
	# Calculamos el tamaño ajustado al zoom (si zoom es 2, vemos la mitad de cosas)
	var cam_size = cam.get_viewport_rect().size / cam.zoom
	# Calculamos la esquina superior izquierda
	var cam_top_left = cam_center - (cam_size / 2)
	
	# Creamos el Rect2 global y le aplicamos el margen (para que no spawneen JUSTO en el borde)
	var camera_rect = Rect2(cam_top_left, cam_size).grow(margin)
	# ---------------------------------
	
	
	# 3. DEFINIR ZONAS (Lógica de exclusión)
	# Usamos intersection para asegurarnos de que las zonas no se salgan del mapa
	
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

	# 4. FILTRAR ZONAS VÁLIDAS
	var valid_zones = []
	
	# Solo agregamos si tienen área positiva (anchura y altura > 0)
	if top_rect.size.x > 0 and top_rect.size.y > 0:
		valid_zones.append(top_rect)
	if bottom_rect.size.x > 0 and bottom_rect.size.y > 0:
		valid_zones.append(bottom_rect)
	if left_rect.size.x > 0 and left_rect.size.y > 0:
		valid_zones.append(left_rect)
	if right_rect.size.x > 0 and right_rect.size.y > 0:
		valid_zones.append(right_rect)
		
	# 5. RETORNO SEGURO
	if valid_zones.is_empty():
		# Fallback: Si el jugador ve TODO el mapa, no hay sitio donde esconderse.
		# Retornamos el centro o null según prefieras.
		print("Advertencia: No hay zona válida fuera de cámara")
		return Vector2.ZERO 
	
	var chosen_zone: Rect2 = valid_zones.pick_random()
	
	var point = Vector2(
		randf_range(chosen_zone.position.x, chosen_zone.end.x),
		randf_range(chosen_zone.position.y, chosen_zone.end.y)
	)
	
	return point


func spawn_enemies():
	#Spawn the enemies in the valid spawnpoints
	for i in range(enemy_dict[current_wave][0]):
		if randf_range(0,100)<elite_prob_percent:
			var e=enemy.instantiate()
			e.scale = e.scale*1.3
			e.position=get_valid_spawnpoint(camera,$"../TileMapLayer")
			e.elite=true
			e.exp_value=int(e.exp_value*pow(exp_elite_growth,current_wave-1))
			e.get_children()[0].health=int(base_elite_hp*pow(hp_elite_growth,current_wave-1))
			$"../Enemies".add_child(e)
			await get_tree().create_timer(spawn_time).timeout
		else:
			var e=enemy.instantiate()
			
			e.position=get_valid_spawnpoint(camera,$"../TileMapLayer")
			e.elite=false
			e.exp_value=int(e.exp_value*pow(exp_growth,current_wave-1))
			e.get_children()[0].health=int(base_hp*pow(hp_growth,current_wave-1))
			$"../Enemies".add_child(e)
			#Delay entre spawn de enemigos
			await get_tree().create_timer(spawn_time).timeout

func spawn_vase():
	for i in range(10):
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
	
	
	await get_tree().create_timer(between_waves).timeout
	wave_text.text = "WAVE "+str(current_wave)
	if current_wave % 5 != 0:
		spawn_enemies()
	else:
		GlobalSignals.emit_signal("miniboss_spawn")
	spawn_vase()
