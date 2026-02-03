extends Node

func cambiar_cancion(nueva_cancion):
	MusicManager.stream= nueva_cancion
	MusicManager.play()
