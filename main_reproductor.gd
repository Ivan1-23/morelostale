extends Node

# Referencias directas a tus nodos
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var container = $SubViewportContainer

func _ready():
	add_to_group("reproductor_principal")
	
	# Forzar pantalla completa en celulares (Android / iOS)
	if DisplayServer.get_name() in ["Android", "iOS"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	# Detectar cambios de tamaño de pantalla
	get_tree().root.size_changed.connect(ajustar_proporcion_pantalla)
	
	# Configurar el contenedor para que no use auto-diseños heredados del celular
	container.anchors_preset = Control.PRESET_TOP_LEFT
	
	# Ajustar por primera vez al iniciar
	ajustar_proporcion_pantalla()
	
	cambiar_escena_interna("res://logo_inicio.tscn")

func ajustar_proporcion_pantalla():
	# 1. Obtener el tamaño de píxeles reales de la pantalla del celular o PC
	var tamano_pantalla = Vector2(get_window().size)
	
	var nuevo_ancho = tamano_pantalla.x
	var nuevo_alto = tamano_pantalla.y
	
	# Proporción exacta de 640x480 (4:3)
	var proporcion_deseada : float = 640.0 / 480.0
	
	# 2. Calcular las dimensiones máximas ideales en 4:3
	if (nuevo_ancho / nuevo_alto) > proporcion_deseada:
		nuevo_ancho = nuevo_alto * proporcion_deseada
	else:
		nuevo_alto = nuevo_ancho / proporcion_deseada
	
	# 3. Forzar al SubViewport a medir SIEMPRE 640x480 píxeles exactos
	sub_viewport.size = Vector2i(640, 480)
	container.size = Vector2(640, 480)
	
	# 4. Calcular el factor de escala necesario para rellenar la pantalla
	var escala_x : float = nuevo_ancho / 640.0
	var escala_y : float = nuevo_alto / 480.0
	var factor_escala = Vector2(escala_x, escala_y)
	
	# Aplicar la escala al contenedor exterior
	container.scale = factor_escala
	
	# 5. CENTRADO HÍBRIDO (PC vs Celular)
	# Si está en Android o iOS, calculamos el margen real de la pantalla de forma absoluta
	if DisplayServer.get_name() in ["Android", "iOS"]:
		# Calculamos cuánto espacio libre queda a los lados en píxeles reales
		var margen_x = (tamano_pantalla.x - (640.0 * escala_x)) / 2.0
		var margen_y = (tamano_pantalla.y - (480.0 * escala_y)) / 2.0
		
		# Forzamos la posición global directamente en el píxel de inicio del juego,
		# obligando a Godot a ignorar el desfase que provocan los joysticks virtuales.
		container.global_position = Vector2(margen_x, margen_y)
	else:
		# En PC mantiene tu cálculo actual que ya funciona impecable
		var tamano_escalado = container.size * factor_escala
		container.global_position = (tamano_pantalla - tamano_escalado) / 2.0


# Cambiar escena de forma diferida para evitar bloqueos
func cambiar_escena_interna(ruta_escena: String):
	for hijo in sub_viewport.get_children():
		hijo.queue_free()
	
	var nueva_escena = load(ruta_escena).instantiate()
	sub_viewport.add_child.call_deferred(nueva_escena)
