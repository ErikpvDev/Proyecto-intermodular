extends State

@export var indicator_scene: PackedScene
@export var attack_delay := 1.2    # Tiempo de carga (el indicador se llena/parpadea)
@export var attack_radius := 90
@export var damage := 20

func enter():
	super.enter()
	
	# 1. Instanciar el aviso (en la posición del boss)
	var indicator = indicator_scene.instantiate()
	owner.add_child(indicator) # Lo anclamos al boss por si acaso, aunque no se mueva
	indicator.position = Vector2.ZERO
	indicator.scale = Vector2.ONE * (attack_radius / 32.0)
	
	# 2. Esperar a que el Boss "cargue" el golpe
	# Aquí podrías poner una animación de "Carga" en tu sprite
	await get_tree().create_timer(attack_delay).timeout
	
	# 3. ¡EL MOMENTO DEL GOLPE!
	execute_scythe_hit(indicator)

func execute_scythe_hit(indicator_node):
	indicator_node.sprite.play("ScytheAttack")
	
	# Comprobar si el jugador está en el área en el momento exacto del giro
	var dist = owner.global_position.distance_to(player.global_position)
	var player_margin = 15.0
	
	if dist <= (attack_radius + player_margin):
		if player.has_method("take_damage"):
			player.take_damage(damage)
	
	# 4. Limpieza: Esperamos a que termine la animación visual antes de irnos
	await get_tree().create_timer(1).timeout
	
	if is_instance_valid(indicator_node):
		indicator_node.queue_free()
	
	get_parent().change_state("Follow")
	
func update(_delta):
	pass
