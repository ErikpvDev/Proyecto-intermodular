extends Node

#Señal para cuando se abre el cofre
@warning_ignore("unused_signal")
signal open_chest(chest)

#Señal para cuando se tenga que actualizar los escudos
@warning_ignore("unused_signal")
signal update_shield(cant)

#Señal para modificar la velocidad
@warning_ignore("unused_signal")
signal update_move_speed(amount)

#Señal para notificar el cambio de ronda
@warning_ignore("unused_signal")
signal miniboss_spawn()

#Señal para modificar la velocidad de ataque
@warning_ignore("unused_signal")
signal update_attack_speed(amount)

#Señal para modificar la velocidad de ataque
@warning_ignore("unused_signal")
signal update_attack_size(amount)

#Señal para recoger un item
@warning_ignore("unused_signal")
signal get_item(item)
