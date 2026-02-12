extends State

@export var indicator_scene: PackedScene
@export var attack_delay := 1.0       # Tiempo desde que sale el aviso hasta el golpe
@export var spawn_attack_delay := 1.5 # Tiempo entre la creación de cada ataque
@export var attack_radius := 40
@export var damage := 2
@export var total_attacks := 3
@export var time_after_dash := 2

func enter():
	super.enter()
	
	await get_tree().create_timer(time_after_dash).timeout
	
	for i in range(total_attacks):
		# 1. Esperar antes de lanzar el siguiente ataque de la serie
		await get_tree().create_timer(spawn_attack_delay).timeout
		
		# 2. Instanciar el indicador (el aviso visual)
		var indicator = indicator_scene.instantiate()
		var spawn_pos = player.global_position # Guardamos la posición exacta del jugador en ese instante
		
		indicator.global_position = spawn_pos
		# Ajuste de escala basado en un sprite base de 64x64
		indicator.scale = Vector2.ONE * (attack_radius / 32.0) 
		get_tree().current_scene.add_child(indicator)
		
		# 3. Lanzar la animación visual del Boss (opcional por cada ataque)
		if animation_player.has_animation("attack_charge"):
			animation_player.play("attack_charge")
		
		# 4. Procesar el daño de forma independiente para este ataque
		check_damage_after_delay(spawn_pos, attack_delay, indicator)

	# 5. Esperar un poco después del último ataque antes de cambiar de estado
	await get_tree().create_timer(attack_delay + 0.2).timeout
	get_parent().change_state("Dash")

# Nueva función para manejar cada explosión por separado
func check_damage_after_delay(pos: Vector2, delay: float, indicator_node: Node2D):
	await get_tree().create_timer(delay).timeout
	indicator_node.sprite.play("attack")
	
	# Verificamos distancia real entre el centro del ataque y el jugador
	# Sumamos un pequeño margen (ej. 20px) para que la colisión sea justa con el cuerpo del player
	var distance = pos.distance_to(player.global_position)
	var player_margin = 20.0 
	
	if distance <= (attack_radius + player_margin):
		if player.has_method("take_damage"):
			player.take_damage(damage)
	
	await get_tree().create_timer(delay).timeout
	
	# Limpiar el indicador
	if is_instance_valid(indicator_node):
		indicator_node.queue_free()
