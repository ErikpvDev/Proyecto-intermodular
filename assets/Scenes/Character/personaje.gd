extends CharacterBody2D

@export var move_speed : float = 100

@export var dash_speed : float = 300
@onready var dashing = false 
var dash_available = true

@export var gold_coins : int = 0

@onready var health_bar: CanvasLayer = $"../UI/health_bar"
@onready var heart_object : PackedScene = preload("res://assets/Scenes/Hearts/heart.tscn")
var hearts_list : Array[TextureRect]
var health = 4

@onready var exp_bar: CanvasLayer = $"../UI"
@export var experience: float = 0
@export var lvl: int = 0

func _ready() -> void:
	# Gets the health bar initial hearts,appends them to the array and shows them on screen ss
	var hearts_parent = health_bar.get_child(0)
	for child in hearts_parent.get_children():
		hearts_list.append(child)
	print(hearts_list)
	
	# Sets Gold to it's initial value
	var gold_coins_number=$"../UI/Gold/HBoxContainer/Label"
	gold_coins_number.text=str(gold_coins)

func take_damage(damage: int) -> void: 
	# if health is over 0, subtract the damage value
	if !dashing:
		if health > 0:
			health-=damage
			update_heart_display()

func update_heart_display():
	# Check the number of hearts to show based on the current health of the player as "idle"
	# and the rest "damaged"
	for i in range(hearts_list.size()):
		if i < health:
			hearts_list[i].get_child(0).play("idle")
		else:
			hearts_list[i].get_child(0).play("damaged")
	# Check if it's the last heart and if so play the "beating" animation if not play the "idle" animation  
	if health > 1:
		hearts_list[0].get_child(0).play("idle")
	else:
		hearts_list[0].get_child(0).play("beating")

func add_heart(cant: int)  -> void:
	# Add the parameter cant to health
	health+=cant
	# Add the new heart sprites to the health bar
	for i in range(cant):
		var heart_temp = heart_object.instantiate()
		health_bar.get_child(0).add_child(heart_temp)

func _physics_process(_delta):
	# Get the direction intented by the input of the player
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	# If the dashing key is pressed activates the dashing status and starts a timer
	if Input.is_action_just_pressed("dash"):
		if dash_available:
			dashing=true
			dash_available=false
			$dash_timer.start()
			$dash_cooldown_timer.start()
		
	# Check if dashing and if so change the value to the dashing speed
	var current_speed_mod = move_speed
	if dashing:
		current_speed_mod = dash_speed
		
	# Check if the player is moving in diagonal to fix the speed and apply the speed select before 
	if input_direction.x!=0 && input_direction.y!=0:
		velocity = input_direction.normalized() * current_speed_mod
	else:
		velocity = input_direction * current_speed_mod
	
	move_and_slide()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	take_damage(1)# Replace with function body.

# Dashing status turning false after timer runs out
func _on_dash_timer_timeout() -> void:
	dashing=false


func _on_dash_cooldown_timer_timeout() -> void:
	dash_available=true
