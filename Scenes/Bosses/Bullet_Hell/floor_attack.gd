extends State

@export var indicator_scene: PackedScene
@export var attack_delay := 1.0       
@export var spawn_attack_delay := 1.5 
@export var attack_radius := 40
@export var damage := 2
@export var total_attacks := 3
@export var time_after_dash := 2

func enter():
	super.enter()
	
	await get_tree().create_timer(time_after_dash).timeout
	
	for i in range(total_attacks):
		await get_tree().create_timer(spawn_attack_delay,false).timeout
		
		var indicator = indicator_scene.instantiate()
		var spawn_pos = player.global_position
		
		indicator.global_position = spawn_pos
		indicator.scale = Vector2.ONE * (attack_radius / 32.0) 
		get_tree().current_scene.add_child(indicator)
		
		check_damage_after_delay(spawn_pos, attack_delay, indicator)

	await get_tree().create_timer(attack_delay + 0.2, false).timeout
	get_parent().change_state("Dash")

func update(_delta):
	pass

func check_damage_after_delay(pos: Vector2, delay: float, indicator_node: Node2D):
	await get_tree().create_timer(delay,false).timeout
	indicator_node.sprite.play("attack")
	
	var distance = pos.distance_to(player.global_position)
	var player_margin = 20.0 
	
	if distance <= (attack_radius + player_margin):
		if player.has_method("take_damage"):
			player.take_damage(damage)
	
	await get_tree().create_timer(delay,false).timeout
	
	if is_instance_valid(indicator_node):
		indicator_node.queue_free()
