extends State

@export var projectile_scene: PackedScene
@export var fire_rate := 3.0          # Tiempo entre ráfagas
@export var burst_count := 3          # Proyectiles por ráfaga
@export var delay_between_shots := 0.2 # Tiempo entre proyectiles de la misma ráfaga
@export var bullet_rounds := 3

@onready var sprite = $"../../AnimatedSprite2D"

var bullet_rounds_shooted := 0
var timer := 0.0


func enter():
	super.enter()
	timer = 0.0

func update(delta):
	timer += delta
	if timer >= fire_rate:
		shoot_burst()
		bullet_rounds_shooted+=1
		timer = 0.0
	if bullet_rounds <= bullet_rounds_shooted:
		get_parent().change_state("Teleport")
	

func shoot_burst():
	flash_warning()
	await get_tree().create_timer(1,false).timeout
	for i in range(burst_count):
		
		await get_tree().create_timer(delay_between_shots,false).timeout
		
		if not is_inside_tree() or get_parent().current_state != self:
			return
		
		var projectile = projectile_scene.instantiate()
		projectile.global_position = owner.global_position
		
		var target_dir = (player.global_position - owner.global_position).normalized()
		projectile.direction = target_dir
		projectile.rotation = target_dir.angle()
		
		get_tree().current_scene.add_child(projectile)
 
func flash_warning():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
