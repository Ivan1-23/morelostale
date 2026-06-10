extends Node

# Referencias directas a tus nodos
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var container = $SubViewportContainer

func _ready():
	add_to_group("reproductor_principal")
	
	# Forzar pantalla completa real en celulares (Android / iOS)
	if DisplayServer.get_name() in ["Android", "iOS"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	# Conectar la señal de cambio de tamaño de pantalla de Godot 4
	get_tree().root.size_changed.connect(ajustar_proporcion_pantalla)
	
	# ==========================================================
	# CORRECCIÓN DE DISEÑO POR CÓDIGO (Limpia los porcentajes del Inspector)
	# ==========================================================
	# Le quitamos el anclaje automático que hereda del editor de celular
	container.anchors_preset = Control.PRESET_TOP_LEFT
	
	# Forzamos las dimensiones base estrictas en píxeles reales (no porcentajes)
	container.size = Vector2(640, 480)
	
	# Definimos el pivote de escalado justo en el centro de la resolución base
	container.pivot_offset = Vector2(320, 240)
	
	# Ajustar por primera vez al iniciar el juego
	ajustar_proporcion_pantalla()
	
	cambiar_escena_interna("res://logo_inicio.tscn")

func ajustar_proporcion_pantalla():
	# 1. Obtener el tamaño de píxeles reales de la pantalla de tu móvil
	var tamano_pantalla = Vector2(get_window().size)
	
	var nuevo_ancho = tamano_pantalla.x
	var nuevo_alto = tamano_pantalla.y
	
	# Proporción exacta de un RPG retro 4:3 (640 / 480 = 1.3333)
	var proporcion_deseada : float = 640.0 / 480.0
	
	# 2. Calcular las dimensiones máximas en 4:3 para la pantalla actual
	if (nuevo_ancho / nuevo_alto) > proporcion_deseada:
		nuevo_ancho = nuevo_alto * proporcion_deseada
	else:
		nuevo_alto = nuevo_ancho / proporcion_deseada
	
	# 3. Calcular la escala limpia de forma aislada para que el compilador no se confunda
	var escala_x : float = nuevo_ancho / 640.0
	var escala_y : float = nuevo_alto / 480.0
	var factor_escala = Vector2(escala_x, escala_y)
	
	# 4. Aplicar el escalado al contenedor
	container.scale = factor_escala
	
	# 5. Forzar la resolución interna de todas tus escenas a 640x480 de forma estricta
	sub_viewport.size = Vector2i(640, 480)
	
	# 6. CÁLCULO DE CENTRADO GLOBAL PERFECTO:
	# Esta fórmula posiciona el juego en el centro físico de la pantalla,
	# cancelando el desplazamiento erróneo hacia las esquinas producido por el pivote de escala.
	var centro_pantalla = tamano_pantalla / 2.0
	container.global_position = centro_pantalla - (container.pivot_offset * factor_escala)

# Cambiar escena de forma diferida con la sintaxis correcta de Godot 4
func cambiar_escena_interna(ruta_escena: String):
	for hijo in sub_viewport.get_children():
		hijo.queue_free()
	
	var nueva_escena = load(ruta_escena).instantiate()
	# Sintaxis nativa de Godot 4 Callable para evitar errores de compilación
	sub_viewport.add_child.call_deferred(nueva_escena)
