extends CanvasGroup

@onready var spawn = false
@onready var wave_timer = $Wave/Wave_timer
const time_const = 5
var time = time_const

func _process(delta):
	if spawn:
		if time > 0:
			time -= delta
			wave_timer.text = "Tiempo: %.1f" % time
		else:
			time=time_const
	
