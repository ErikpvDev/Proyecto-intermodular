extends TextureRect

@onready var label_cantidad = $Cantidad

func set_item(item: Resource, cantidad: int):
	texture = item.icon
	
	if cantidad > 1:
		label_cantidad.text = str("x") + str(cantidad)
		label_cantidad.show()
	else:
		label_cantidad.hide()
