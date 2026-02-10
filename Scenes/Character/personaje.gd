extends CharacterBody2D

#ATTACK
@export var damage: float = 5
@onready var damage_multiplier: float = 1

#MOVEMENT
@onready var movement: Node = $Movement
@onready var is_dodging

#DODGE CHANCE
@onready var dodge_chance: float = 0

#CRIT CHANCE
@onready var crit_chance: float = 0

#ATTACK SPEED
@onready var attack_speed: float = 0

#ATTACK SIZE
@onready var attack_size: float = 1

#HEARTS/HEALTH
@onready var health_bar: CanvasLayer = $"../UI/health_bar"
@onready var heart_object = preload("res://Scenes/Hearts/heart.tscn")
@onready var health: Node = $Health

#SHIELD
@onready var shield : int = 0
@onready var max_shield: int = 3
@onready var shield_bar: CanvasLayer = $"../UI/ShieldDisplay"

#EXP/LVL
@onready var exp_bar: TextureProgressBar = $"../UI/Exp/TextureProgressBar"
@onready var exp_lvl_text: Label = $"../UI/Exp/Label"
@onready var experience: Node = $Experience

#GOLD
@export var gold_coins : int = 0
@onready var gold_coins_number=$"../UI/Gold/HBoxContainer/Label"
@onready var gold_scene: Node = $Gold

#ENEMIES
var enemies_hit_this_attack=[]
@onready var distance_to_closest_enemy

@onready var enemies=[]
var closest_enemy_direction
var closest_enemy

#VARIABLES------------------------------------------------------------------------------------------------

func _ready() -> void:	
	GlobalSignals.update_gold.connect(update_gold)
	GlobalSignals.add_gold.connect(add_gold)
	GlobalSignals.get_item.connect(get_item)
	
	GlobalSignals.emit_signal("update_shield",shield)
	GlobalSignals.emit_signal("update_stats")
	
	health.max_health = 5 
	
	# Gets the health bar initial hearts,appends them to the array and shows them on screen
	for i in range(health.max_health):
		var heart_temp = heart_object.instantiate()
		heart_temp.custom_minimum_size = Vector2(34,34)
		health_bar.get_child(0).add_child(heart_temp)
		
	health.health=health.max_health
	update_heart_display()
	# Sets Gold to its initial value
	gold_coins_number.text=str(gold_coins)
	
	
	$AttackArea/CollisionShape2D.disabled=true
	$AttackArea/AnimatedSprite2D.visible=false
	$AttackArea/attack_cooldown.start()
	
	#GlobalSignals.emit_signal("update_stats")

func _process(delta):
	update_animation()
	movement.movement(delta)
	enemies = $"../Enemies".get_children()

func update_heart_display():
	# Check the number of hearts to show based on the current health of the player as "idle"
	# and the rest "damaged"
	var hearts = health_bar.get_child(0).get_children()
	
	for i in range(hearts.size()):
		hearts[i].custom_minimum_size = Vector2(34,34)
	
	for i in range(hearts.size()):
		if i < health.health:
			hearts[i].get_child(0).play("idle")
		else:
			hearts[i].get_child(0).play("damaged")
	# Check if it's the last heart and if so play the "beating" animation if not play the "idle" animation  
	if health.health > 1:
		hearts[0].get_child(0).play("idle")
	else:
		hearts[0].get_child(0).play("beating")

func add_health(amount: int) -> void:
	health.add_health(amount)

func add_max_health(amount: int)->void:
	if health.max_health < 10:
		health.add_max_health(amount)
		update_heart_display()
	
func _on_health_health_changed(new_health: Variant) -> void:
	health.health=new_health

func _on_health_max_health_changed(new_health: Variant, prev_max_health: Variant) -> void:
	for i in range(new_health-prev_max_health):
		var heart_temp = heart_object.instantiate()
		health_bar.get_child(0).add_child(heart_temp)
	update_heart_display()

func take_damage(amount: int) -> void:
	if !movement.dashing:
		if (!randf()<dodge_chance):
			if shield >= 1:
				shield=shield-1
				GlobalSignals.emit_signal("update_shield",shield)
			else:	
				health.take_damage(amount)
				update_heart_display()
				$AnimationPlayer.play("hit")

func add_exp(amount: int) -> void:
	experience.add_exp(amount)

func update_animation():
	if movement.dashing:
		$AnimatedSprite2D.play("Dash")
	else:
		if velocity.x != 0:
			if velocity.x > 0:
				$AnimatedSprite2D.play("Walk_right")
			else:
				$AnimatedSprite2D.play("Walk_left")
		else:
			if velocity.y != 0:
				if velocity.y > 0:
					$AnimatedSprite2D.play("Walk_down")
				else:
					$AnimatedSprite2D.play("Walk_up")
			else:
				$AnimatedSprite2D.play("Idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	take_damage(body.damage)

func attack():
	distance_to_closest_enemy = INF
	for i in enemies:
		if position.distance_to(i.position)<distance_to_closest_enemy:
			closest_enemy = i
			distance_to_closest_enemy = position.distance_to(i.position)
	if !enemies.is_empty():
		closest_enemy_direction = Vector2(closest_enemy.position-position).normalized()
		enemies_hit_this_attack.clear()
		$AttackArea/AnimatedSprite2D.position = Vector2(32,32)*closest_enemy_direction
		$AttackArea/CollisionShape2D.position = Vector2(32,32)*closest_enemy_direction
	
		$AttackArea/AnimatedSprite2D.rotation = closest_enemy_direction.angle()
	
		$AttackArea/AnimatedSprite2D.play("attacking")
		$AttackArea/AnimatedSprite2D.visible=true
		$AttackArea/CollisionShape2D.disabled=false
	
		$AttackArea/AttackTimer.start()
	
func _on_attack_timer_timeout() -> void:
	$AttackArea/AnimatedSprite2D.visible=false
	$AttackArea/CollisionShape2D.disabled=true

func _on_attack_cooldown_timeout() -> void:
	attack()
	$AttackArea/attack_cooldown.start()
	
func _on_attack_area_area_entered(area: Area2D) -> void:
	if area in enemies_hit_this_attack:
		return
	enemies_hit_this_attack.append(area)
	
	var parent = area.get_parent()
	
	if parent.has_method("take_damage") && parent!=self:
		if (randf()>crit_chance):
			parent.take_damage(damage*damage_multiplier, false)
		else:
			parent.take_damage(damage*damage_multiplier*2, true)

func get_item(item: ItemData):
	damage += item.damage_bonus
	damage_multiplier *= item.damage_multiplier
	GlobalSignals.emit_signal("update_move_speed", item.move_speed_bonus)
	dodge_chance += item.dodge_chance_bonus
	if (dodge_chance > 0.7):
		dodge_chance = 0.7
	crit_chance += item.crit_chance_bonus
	if (item.attack_speed_bonus > 0):
		attack_speed += item.attack_speed_bonus
		GlobalSignals.emit_signal("update_attack_speed", attack_speed)
	if (attack_size < 2.25 && item.projectile_size_multiplier>1):
		attack_size *= item.projectile_size_multiplier
		GlobalSignals.update_attack_size.emit(item.projectile_size_multiplier)
	if (shield<3):
		shield += item.shield_bonus
		if (shield>3):
			shield = 3
		GlobalSignals.emit_signal("update_shield", shield)
	add_max_health(item.max_hp_bonus)
	add_health(item.max_hp_bonus)
	update_heart_display()
	GlobalSignals.emit_signal("update_stats")
	#print(damage)
	#print(damage_multiplier)
	#print(movement.move_speed)
	#print(dodge_chance)
	#print(crit_chance)
	#print(attack_speed)
	#print(attack_size)
	#print(shield)
	#print(health.health)

func add_gold(amount: int):
	gold_coins += amount
	update_gold()
	
func update_gold():
	gold_coins_number.text = str(gold_coins)
