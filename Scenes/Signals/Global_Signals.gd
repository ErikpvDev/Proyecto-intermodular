extends Node

#Señal para cuando se abre el cofre
signal open_chest(chest)

#Señal para cuando se tenga que actualizar los escudos
signal update_shield(cant)

#Señal para modificar la velocidad
signal update_move_speed(amount)

#Señal para notificar el cambio de ronda
signal miniboss_spawn()
