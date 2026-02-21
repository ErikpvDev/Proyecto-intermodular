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

#Señal para añadir un corazón
@warning_ignore("unused_signal")
signal add_health()

#Señal para añadir vida máxima
@warning_ignore("unused_signal")
signal add_max_health()

#Señal para actualizar el display de los corazones
@warning_ignore("unused_signal")
signal update_heart_display()

#Señal para añadir escudo
@warning_ignore("unused_signal")
signal add_shield()

#Señal para cuando muere el personaje
@warning_ignore("unused_signal")
signal die()

#Señal para cuando tiene que abrirse el menu de muerte
@warning_ignore("unused_signal")
signal death_menu()

#Señal para mostrar el menu de victoria
@warning_ignore("unused_signal")
signal victory_menu(total_time)
