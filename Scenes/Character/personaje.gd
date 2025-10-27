extends CharacterBody2D

# EXPORT -------------------------------------------------------------------------------------------------
#GOLD
@export var gold_coins : int = 0

@export var attack_cooldown: float = 1.0
@export var damage: int = 10

var enemies_hit_this_attack=[]

#ONREADY -------------------------------------------------------------------------------------------------
#MOVEMENT
#EXP/LVL
@onready var exp_bar: TextureProgressBar = $"../UI/Exp/TextureProgressBar"
@onready var exp_lvl_text: Label = $"../UI/Exp/Label"
#GOLD
@onready var gold_coins_number=$"../UI/Gold/HBoxContainer/Label"
#HEARTS
@onready var health_bar: CanvasLayer = $"../UI/health_bar"
@onready var heart_object : PackedScene = preload("res://Scenes/Hearts/heart.tscn")

@onready var movement: Node = $Movement
@onready var health: Node = $Health
@onready var experience: Node = $Experience

#VARIABLES------------------------------------------------------------------------------------------------
#HEALTH
var hearts_list : Array[TextureRect]

func _ready() -> void:
	# Gets the health bar initial hearts,appends them to the array and shows them on screen
	var hearts_parent = health_bar.get_child(0)
	for child in hearts_parent.get_children():
		hearts_list.append(child)
	print(hearts_list)
	
	# Sets Gold to its initial value
	gold_coins_number.text=str(gold_coins)
	
	$AttackArea/CollisionShape2D.disabled=true
	$AttackArea/Sprite2D.visible=false
	$attack_cooldown.start()


func update_heart_display():
	# Check the number of hearts to show based on the current health of the player as "idle"
	# and the rest "damaged"
	for i in range(hearts_list.size()):
		if i < health.health:
			hearts_list[i].get_child(0).play("idle")
		else:
			hearts_list[i].get_child(0).play("damaged")
	# Check if it's the last heart and if so play the "beating" animation if not play the "idle" animation  
	if health.health > 1:
		hearts_list[0].get_child(0).play("idle")
	else:
		hearts_list[0].get_child(0).play("beating")

func add_health(amount: int) -> void:
	health.add_health(amount)

func add_max_health(amount: int)->void:
	health.add_max_health(amount)
	update_heart_display()

func take_damage(amount: int) -> void: 
	health.take_damage(amount)
	update_heart_display()

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

func _physics_process(delta):
	update_animation()
	movement.movement(delta)

func _on_health_health_changed(new_health: Variant) -> void:
	health.health=new_health

func _on_health_max_health_changed(new_health: Variant, prev_max_health: Variant) -> void:
	for i in range(new_health-prev_max_health):
		var heart_temp = heart_object.instantiate()
		health_bar.get_child(0).add_child(heart_temp)
	update_heart_display()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	add_exp(50)


func _on_experience_level_up(lvl: Variant) -> void:
		experience.experience-=experience.exp_needed_lvl
		exp_lvl_text.text="lvl: "+str(experience.lvl)
		
	
	
func attack():
	enemies_hit_this_attack.clear()
	
	$AttackArea/Sprite2D.visible=true
	$AttackArea/CollisionShape2D.disabled=false
	
	$AttackTimer.start()
	
	
func _on_attack_timer_timeout() -> void:
	$AttackArea/Sprite2D.visible=false
	$AttackArea/CollisionShape2D.disabled=true

func _on_attack_cooldown_timeout() -> void:
	attack()
	$attack_cooldown.start()
	
func _on_attack_area_area_entered(area: Area2D) -> void:
	if area in enemies_hit_this_attack:
		return
	enemies_hit_this_attack.append(area)
	
	var parent = area.get_parent()
	
	if parent.has_method("take_damage"):
		parent.take_damage(damage)
