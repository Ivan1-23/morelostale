extends Node

# Referencias directas a tus nodos
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var container = $SubViewportContainer

func _ready():
	add_to_group("reproductor_principal")
	
	# === SOLUCCIÓN AL ORDEN DE CARGA ===
	# Usamos call_deferred para asegurarnos de que esta línea se ejecute 
	# JUSTO DESPUÉS de que todos los nodos del árbol estén 100% listos.
	# Cambia "MenuSistema" y "ControlesTactiles" por los nombres EXACTOS de tus nodos.
	call_deferred("_conectar_controles_tactiles")
	
	# Forzar pantalla completa real en celulares (Android / iOS)
	if DisplayServer.get_name() in ["Android", "iOS"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	# Detectar cambios de tamaño de pantalla
	get_tree().root.size_changed.connect(ajustar_proporcion_pantalla)
	
	# Configurar el contenedor para que no use auto-diseños heredados del celular
	container.anchors_preset = Control.PRESET_TOP_LEFT
	
	# Ajustar por primera vez al iniciar
	ajustar_proporcion_pantalla()
	
	cambiar_escena_interna("res://logo_inicio.tscn")

# Función de apoyo para conectar los nodos de forma segura
func _conectar_controles_tactiles():
	# Comprobamos con nombres exactos que existan en el árbol antes de asignar
	if has_node("MenuSistema") and has_node("ControlesTactiles"):
		$MenuSistema.touch_buttons = $ControlesTactiles
	else:
		# Si tus nodos tienen otros nombres (ej. con minúsculas), pon una alerta en la consola
		print("Advertencia: No se encontraron los nodos con esos nombres exactos en la raíz.")

func ajustar_proporcion_pantalla():
	# 1. ¡CLAVE!: Cambiado a visible_rect para que el depurador no lo mande a la derecha
	var tamano_pantalla = get_viewport().get_visible_rect().size
	
	var nuevo_ancho = tamano_pantalla.x
	var nuevo_alto = tamano_pantalla.y
	
	# Proporción exacta de 3:4 (640x480)
	var proporcion_deseada : float = 640.0 / 480.0
	
	# 2. Calcular las dimensiones máximas ideales en 3:4
	if (nuevo_ancho / nuevo_alto) > proporcion_deseada:
		nuevo_ancho = nuevo_alto * proporcion_deseada
	else:
		nuevo_alto = nuevo_ancho / proporcion_deseada
	
	# 3. Forzar al SubViewport a medir SIEMPRE 640x480 píxeles exactos
	var base_x = 640.0
	var base_y = 480.0
	
	sub_viewport.size = Vector2i(int(base_x), int(base_y))
	container.size = Vector2(base_x, base_y)
	
	# 4. Calcular el factor de escala elástico y fluido
	var escala_x : float = nuevo_ancho / base_x
	var escala_y : float = nuevo_alto / base_y
	var factor_escala = Vector2(escala_x, escala_y)
	
	# Aplicar la escala al contenedor exterior
	container.scale = factor_escala
	
	# 5. CENTRADO ABSOLUTO UNIFICADO (PC y Celular)
	# Esto calcula el centro real libre de los botones táctiles y clava el juego ahí
	var tamano_escalado = container.size * factor_escala
	container.global_position = (tamano_pantalla - tamano_escalado) / 2.0


# Cambiar escena de forma diferida para evitar bloqueos
func cambiar_escena_interna(ruta_scene: String):
	for hijo in sub_viewport.get_children():
		hijo.queue_free()
	
	var nueva_escena = load(ruta_scene).instantiate()
	sub_viewport.add_child.call_deferred(nueva_escena)
