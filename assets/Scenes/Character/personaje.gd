extends CharacterBody2D

@export var move_speed : float = 100
@onready var health_bar: CanvasLayer = $"../health_bar"

var hearts_list : Array[TextureRect]
var health = 4

func _ready() -> void:
		var hearts_parent = health_bar.get_child(0)
		for child in hearts_parent.get_children():
			hearts_list.append(child)
		print(hearts_list)

func take_damage():
	print(health)
	if health > 0:
		health-=1
		update_heart_display()

func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible= i < health
	if health == 1:
		hearts_list[0].get_child(0).play("beating")
	elif health > 1:
		hearts_list[0].get_child(0).play("idle")

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	if input_direction.x!=0 && input_direction.y!=0:
		velocity = input_direction.normalized() * move_speed
	else:
		velocity = input_direction * move_speed	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	take_damage()# Replace with function body.
