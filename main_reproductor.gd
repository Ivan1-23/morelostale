extends Node

# Referencia directa al Viewport y su contenedor donde corre el juego
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var container = $SubViewportContainer

func _ready():
	add_to_group("reproductor_principal")
	
	# Forzar pantalla completa real en celulares (Android / iOS)
	if DisplayServer.get_name() in ["Android", "iOS"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	# Conectar la señal de cambio de tamaño de pantalla (Sintaxis correcta de Godot 4)
	get_tree().root.size_changed.connect(ajustar_proporcion_pantalla)
	
	# Ajustar por primera vez al iniciar el juego
	ajustar_proporcion_pantalla()
	
	cambiar_escena_interna("res://logo_inicio.tscn")

func ajustar_proporcion_pantalla():
	# 1. Obtener el tamaño real de la pantalla del dispositivo/celular en pixeles flotantes
	var tamano_pantalla = Vector2(get_window().size)
	
	var nuevo_ancho = tamano_pantalla.x
	var nuevo_alto = tamano_pantalla.y
	
	# Proporción exacta de 640x480 (4:3 -> 1.33333)
	var proporcion_deseada : float = 640.0 / 480.0
	
	# 2. Calcular el tamaño máximo respetando el formato 4:3
	if (nuevo_ancho / nuevo_alto) > proporcion_deseada: 
		# La pantalla es más ancha que el juego (típico en celulares horizontales)
		nuevo_ancho = nuevo_alto * proporcion_deseada
	else:
		# La pantalla es más alta o estrecha que el juego
		nuevo_alto = nuevo_ancho / proporcion_deseada
	
	# 3. Forzar el tamaño del contenedor externo al tamaño 4:3 calculado
	container.size = Vector2(nuevo_ancho, nuevo_alto)
	
	# 4. Asegurar que la resolución interna del SubViewport coincida de forma elástica
	sub_viewport.size = Vector2i(int(nuevo_ancho), int(nuevo_alto))
	
	# 5. Congelar de forma estricta el renderizado 2D interno para que no revele más mapa
	sub_viewport.size_2d_override = Vector2i(640, 480)
	sub_viewport.size_2d_override_stretch = true
	
	container.global_position = (tamano_pantalla - container.size) / 2.0
# Cambiar escena de forma diferida para evitar bloqueos

func cambiar_escena_interna(ruta_escena: String):
	for hijo in sub_viewport.get_children():
		hijo.queue_free()
	
	var nueva_escena = load(ruta_escena).instantiate()
	sub_viewport.add_child.call_deferred(nueva_escena)
