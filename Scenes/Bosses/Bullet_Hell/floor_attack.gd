extends State

@export var indicator_scene: PackedScene
@export var attack_delay := 1       # tiempo hasta que hace daño
@export var spawn_attack_delay := 1
@export var attack_radius := 80.0     # tamaño del área de daño
@export var damage := 2
@export var total_attacks := 3

func enter():
	super.enter()
	
	for i in range(total_attacks):
		await get_tree().create_timer(spawn_attack_delay).timeout
		var indicator = indicator_scene.instantiate()
		indicator.global_position = player.global_position   # marcar al jugador
		indicator.scale = Vector2.ONE * attack_radius / 64.0 # ajustar tamaño si tu sprite es 64x64
		get_tree().current_scene.add_child(indicator)
	
		animation_player.play("attack_charge") # animación del boss
	
		# 2️⃣ Esperar el tiempo de telegráfico
		await get_tree().create_timer(attack_delay).timeout
	
		# 3️⃣ Hacer daño si el jugador sigue en el área
		if player.global_position.distance_to(indicator.global_position) <= attack_radius:
			player.take_damage(damage)
	
		# 4️⃣ Limpiar indicador
		indicator.queue_free()
		
	# 5️⃣ Volver al siguiente estado
	get_parent().change_state("Dash")
