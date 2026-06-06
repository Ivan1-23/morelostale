extends StaticBody2D

@export var id_objeto: String = "tijeras_escolares"
@export var nombre_objeto: String = "TijerasEscolares"

var jugador_interactuando: Node = null
var cuadro_dialogo: Node = null

# Esta función es llamada por el RayCast2D del jugador al presionar 'Acción' (Z)
func interactuar(nodo_jugador: Node) -> void:
	jugador_interactuando = nodo_jugador
	
	# Congelamos temporalmente al jugador para que no camine mientras decide
	if "puede_moverse" in jugador_interactuando:
		jugador_interactuando.puede_moverse = false
	
	# Buscamos el cuadro de diálogo en la escena actual
	cuadro_dialogo = owner.get_node_or_null("cuadro_dialogo")
	if not cuadro_dialogo:
		cuadro_dialogo = get_tree().get_first_node_in_group("dialogo")
		
	if cuadro_dialogo:
		# UNIVERSAL: Nos conectamos a la señal. Cuando el jugador elija SÍ o NO, 
		# el cuadro nos avisará de vuelta ejecutando '_on_respuesta_recibida'.
		if not cuadro_dialogo.respuesta_pregunta.is_connected(_on_respuesta_recibida):
			cuadro_dialogo.respuesta_pregunta.connect(_on_respuesta_recibida)
			
		# Enviamos el paquete de datos estructurado al cuadro de diálogo
		cuadro_dialogo.iniciar_dialogo(obtener_datos_pregunta())

# Estructura del mensaje de texto (Formato idéntico al de tus letreros)
func obtener_datos_pregunta() -> Array:
	return [
		{
			"texto": "* Encontraste un " + nombre_objeto,
			"retrato": null,
			"voz": null,
			"es_pregunta": false # Esto le dice al cuadro de diálogo que encienda el corazón y use las flechas
		},
		{ "texto":"*¿Deseas recogerlo?\n\n            SÍ              NO",
			"retrato": null,
			"voz": null,
			"es_pregunta": true
		}
	]

# Esta función "escucha" la decisión final del cuadro de diálogo
func _on_respuesta_recibida(acepto: bool) -> void:
	# CRÍTICO: Desconectamos la señal inmediatamente para que el cuadro_dialogo
	# quede libre y pueda ser usado por cualquier otra pregunta del juego.
	if cuadro_dialogo and cuadro_dialogo.respuesta_pregunta.is_connected(_on_respuesta_recibida):
		cuadro_dialogo.respuesta_pregunta.disconnect(_on_respuesta_recibida)
		
	if acepto:
		# --- ACCIÓN SI ELIGE SÍ ---
		# Comprobamos que el inventario global no esté lleno (límite de 8 objetos)
		if diccionario_global.inventario.size() < 8:
			diccionario_global.añadir_objeto(id_objeto)
			print("* Añadiste " + nombre_objeto + " a tu inventario.")
			
			# Nota: No reactivamos 'puede_moverse' aquí. Dejamos que el script 
			# de tu jugador lo haga de forma nativa con la señal 'dialogo_terminado'.
			queue_free() # El objeto se destruye y desaparece del mapa
		else:
			# Si el inventario está lleno, el objeto permanece en el suelo
			print("* Tu inventario está lleno.")
	else:
		# --- ACCIÓN SI ELIGE NO ---
		print("* Lo dejaste en el suelo.")
