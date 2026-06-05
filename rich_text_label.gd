extends RichTextLabel  # <-- SÍ, va aquí arriba obligatoriamente

func _ready() -> void:
	# Al arrancar la escena calculamos el texto inicial
	actualizar_texto_inventario()

# Esta función la llamará menu.gd cada vez que cambie el inventario
func actualizar_texto_inventario() -> void:
	var texto_final = ""
	
	# Usamos el singleton 'diccionario_global' (en minúsculas)
	var inventario = diccionario_global.inventario
	var base_datos = diccionario_global.BASE_DE_DATOS_OBJETOS
	
	# Recorremos los 8 espacios máximos del inventario
	for i in range(8):
		if i < inventario.size():
			var id_item = inventario[i]
			var datos_item = base_datos.get(id_item, {})
			var nombre_item = datos_item.get("nombre", "Desconocido")
			
			# Agregamos el nombre del objeto y un salto de línea
			texto_final += nombre_item + "\n"
		else:
			# Dejamos la línea en blanco si el espacio está vacío
			texto_final += "\n"
			
	# Asignamos todo el bloque de texto enriquecido procesado directamente
	text = texto_final
