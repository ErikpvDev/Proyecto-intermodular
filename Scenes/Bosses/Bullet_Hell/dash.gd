extends State

@export var dash_speed := 1300.0       
@export var dash_duration := 0.15    
@export var safe_distance := 100    

var dash_direction := Vector2.ZERO
var dash_timer := 0.0
var start_position := Vector2.ZERO
var target_position := Vector2.ZERO

func enter():
	super.enter()
	
	start_position = owner.global_position
	
	var direction_to_player = (player.global_position - start_position).normalized()
	
	target_position = player.global_position - direction_to_player * safe_distance
	
	dash_direction = (target_position - start_position).normalized()
	
	dash_timer = dash_duration
	owner.velocity = dash_direction * dash_speed

func update(_delta):
	pass

func _physics_process(delta):
	if dash_timer > 0.0:
		dash_timer -= delta
		owner.move_and_slide()
		
		if owner.global_position.distance_to(target_position) <= 5.0:
			dash_timer = 0.0
	else:
		owner.velocity = Vector2.ZERO
		var chance = randi_range(1,2);
		if chance == 1:
			get_parent().change_state("FloorAttack")
		else:
			get_parent().change_state("BulletHell")
