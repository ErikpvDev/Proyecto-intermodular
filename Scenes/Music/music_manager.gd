extends Node

@onready var audio = $AudioStreamPlayer

func cambiar_cancion(nueva_cancion):
	MusicManager.stream = nueva_cancion
	audio.play()
	
func stop():
	audio.stop()
	
func play():
	if not audio.playing:
		audio.play()
