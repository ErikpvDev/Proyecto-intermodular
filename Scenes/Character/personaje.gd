extends CharacterBody2D

#ATTACK
@export var attack_cooldown: float = 1.0
@export var damage: int = 10

#EXP/LVL
@onready var exp_bar: TextureProgressBar = $"../UI/Exp/TextureProgressBar"
@onready var exp_lvl_text: Label = $"../UI/Exp/Label"
@onready var experience: Node = $Experience

#GOLD
@export var gold_coins : int = 0
@onready var gold_coins_number=$"../UI/Gold/HBoxContainer/Label"

#HEARTS/HEALTH
@onready var health_bar: CanvasLayer = $"../UI/health_bar"
@onready var heart_object = preload("res://Scenes/Hearts/heart.tscn")
@onready var health: Node = $Health

#MOVEMENT
@onready var movement: Node = $Movement

#ENEMIES
var enemies_hit_this_attack=[]
@onready var distance_to_closest_enemy

@onready var enemies=[]
var closest_enemy_direction
var closest_enemy

#VARIABLES------------------------------------------------------------------------------------------------

func _ready() -> void:
	# Gets the health bar initial hearts,appends them to the array and shows them on screen
	for i in range(health.max_health):
		var heart_temp = heart_object.instantiate()
		heart_temp.custom_minimum_size = Vector2(34,34)
		health_bar.get_child(0).add_child(heart_temp)
		
	update_heart_display()
	# Sets Gold to its initial value
	gold_coins_number.text=str(gold_coins)
	
	$AttackArea/CollisionShape2D.disabled=true
	$AttackArea/Sprite2D.visible=false
	$AttackArea/attack_cooldown.start()

func _process(delta):
	update_animation()
	movement.movement(delta)
	enemies = $"../Enemies".get_children()

func update_heart_display():
	# Check the number of hearts to show based on the current health of the player as "idle"
	# and the rest "damaged"
	for i in range(health_bar.get_child(0).get_children().size()):
		if i < health.health:
			health_bar.get_child(0).get_children()[i].get_child(0).play("idle")
		else:
			health_bar.get_child(0).get_children()[i].get_child(0).play("damaged")
	# Check if it's the last heart and if so play the "beating" animation if not play the "idle" animation  
	if health.health > 1:
		health_bar.get_child(0).get_children()[0].get_child(0).play("idle")
	else:
		health_bar.get_child(0).get_children()[0].get_child(0).play("beating")

func add_health(amount: int) -> void:
	health.add_health(amount)

func add_max_health(amount: int)->void:
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

func _on_area_2d_body_entered(_body: Node2D) -> void:
	take_damage(1)

func attack():
	distance_to_closest_enemy = INF
	for i in enemies:
		if position.distance_to(i.position)<distance_to_closest_enemy:
			closest_enemy = i
			distance_to_closest_enemy = position.distance_to(i.position)
	if !enemies.is_empty():
		closest_enemy_direction = Vector2(closest_enemy.position-position).normalized()
		enemies_hit_this_attack.clear()
		$AttackArea/Sprite2D.position = Vector2(16,16)*closest_enemy_direction
		$AttackArea/CollisionShape2D.position = Vector2(16,16)*closest_enemy_direction
	$AttackArea/Sprite2D.visible=true
	$AttackArea/CollisionShape2D.disabled=false
	
	$AttackArea/AttackTimer.start()
	
func _on_attack_timer_timeout() -> void:
	$AttackArea/Sprite2D.visible=false
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
		parent.take_damage(damage)
