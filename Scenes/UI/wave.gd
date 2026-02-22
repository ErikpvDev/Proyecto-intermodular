extends Node2D

@onready var spawn = $"../../Spawn"

@onready var between_waves=5
@onready var wave_text = $"Wave/Label"
@onready var wave_timer = $"Wave/Wave_timer"

@export var time_between_waves: float = 3

var between_waves_screen_timer=false
var time

func _ready():
	time=time_between_waves
	spawn.connect("between_waves_screen_timer",Callable(self,"_on_between_waves_screen_timer"))
	
func _physics_process(delta: float) -> void:
	if between_waves_screen_timer:
		if time > 0.1:
			time -= delta
			wave_timer.text = "NEXT WAVE: %.1f" % time
			wave_timer.visible=true
		else:
			time=time_between_waves
			between_waves_screen_timer=false
			wave_timer.visible=false
			
func _on_between_waves_screen_timer():
	between_waves_screen_timer=true
