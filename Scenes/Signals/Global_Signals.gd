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
signal miniboss_spawn(current_wave)

#Señal para modificar la velocidad de ataque
@warning_ignore("unused_signal")
signal update_attack_speed(amount)

#Señal para modificar la velocidad de ataque
@warning_ignore("unused_signal")
signal update_attack_size(amount)

#Señal para recoger un item
@warning_ignore("unused_signal")
signal get_item(item)

#Señal cuando muere un jefe
@warning_ignore("unused_signal")
signal show_shop()

#Señal cuando salimos de la tienda
@warning_ignore("unused_signal")
signal leave_shop()

#Señal para actualizar el display del oro
@warning_ignore("unused_signal")
signal update_gold()

#Señal para añadir oro
@warning_ignore("unused_signal")
signal add_gold()

#Señal para actualizar el display de las stats
@warning_ignore("unused_signal")
signal update_stats()
