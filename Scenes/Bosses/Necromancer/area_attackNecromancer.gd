extends State

@export var indicator_scene: PackedScene
@export var attack_delay := 1.2  
@export var attack_radius := 90
@export var damage := 2

func enter():
	super.enter()
	
	var indicator = indicator_scene.instantiate()
	owner.add_child(indicator)
	indicator.position = Vector2.ZERO
	indicator.scale = Vector2.ONE * (attack_radius / 32.0)
	
	
	await get_tree().create_timer(attack_delay,false).timeout
	
	execute_scythe_hit(indicator)

func execute_scythe_hit(indicator_node):
	indicator_node.sprite.play("ScytheAttack")
	
	# Comprobar si el jugador está en el área en el momento exacto del giro
	var dist = owner.global_position.distance_to(player.global_position)
	var margin = 25
	
	if dist <= (attack_radius+margin):
		if player.has_method("take_damage"):
			player.take_damage(damage)
	
	await get_tree().create_timer(1,false).timeout
	
	if is_instance_valid(indicator_node):
		indicator_node.queue_free()
	
	get_parent().change_state("Teleport")
	
func update(_delta):
	pass
