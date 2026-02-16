extends State # Asumo que tu clase base se llama State

@export var teleport_distance: float = 60.0  # Distancia detrás del jugador
@export var fade_duration: float = 0.3       # Tiempo de desaparición

func enter():
	start_teleport()

func start_teleport():
	# 1. Efecto visual de desaparición (opcional pero recomendado)
	var tween = create_tween()
	tween.tween_property(owner, "modulate:a", 0.0, fade_duration)
	
	await tween.finished
	
	var direction = Vector2.RIGHT
	if player.velocity.x != 0:
		direction = player.velocity.normalized()
	elif player.get_node("AnimatedSprite2D").flip_h: 
		direction = Vector2.LEFT
	
	# La posición destino es la del jugador menos su dirección por la distancia
	var target_pos = player.global_position - (direction * teleport_distance)
	
	# 3. Mover al Boss
	owner.global_position = target_pos
	
	# 4. Reaparecer
	var tween_in = create_tween()
	tween_in.tween_property(owner, "modulate:a", 1.0, fade_duration)
	
	await tween_in.finished
	
	get_parent().change_state("AreaAttack") 

func exit():
	pass
