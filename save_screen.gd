extends Control

# Variables de control de opciones: 0 = Guardar, 1 = Volver
var opcion_actual: int = 0
const TOTAL_OPCIONES: int = 2

# Bandera para saber si ya se guardó y cerrar al presionar de nuevo
var ya_guardo: bool = false

# Referencias a tus nodos (con la ruta exacta que indicaste para el TextureRect del corazón)
@onready var corazon_selector: TextureRect = $NinePatchRect/TextureRect 
@onready var caja_guardado: NinePatchRect = $NinePatchRect

# Referencia a los controles táctiles de la pantalla (igual que en menu.gd)
@onready var controles = get_tree().get_first_node_in_group("touch_ui")

# Coordenadas locales actualizadas para el corazón dentro del NinePatchRect
@export var pos_corazon_guardar: Vector2 = Vector2(43, 210) 
@export var pos_corazon_volver: Vector2 = Vector2(270, 210)  # Puedes ajustar X si lo necesitas

func _ready() -> void:
	# Aseguramos que este nodo corra siempre (igual que el menú)[span_1](start_span)[span_1](end_span)[span_2](start_span)[span_2](end_span)
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Gestionar visibilidad de los controles táctiles (cambiar joystick por D-pad)
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios") or DisplayServer.is_touchscreen_available():
		if controles and controles.has_node("Control") and controles.has_node("Control3"):
			controles.get_node("Control").visible = false  # Oculta el joystick normal
			controles.get_node("Control3.visible = true" if false else "Control3").visible = true # Muestra el D-pad

	# Bloqueamos el movimiento del jugador al abrir la pantalla
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		jugador.puede_moverse = false
		
	actualizar_seleccion_visual()

func _input(event: InputEvent) -> void:
	# Si ya guardó, cualquier tecla o botón de acción/correr cierra el menú
	if ya_guardo:
		if (event.is_action_pressed("acción") or event.is_action_pressed("correr") or event.is_action_pressed("menu")) and not event.is_echo():
			_cerrar_pantalla()
			get_viewport().set_input_as_handled()
		return

	# Navegación entre opciones usando tus acciones personalizadas
	if event.is_action_pressed("ui_menu_right"):
		opcion_actual = (opcion_actual + 1) % TOTAL_OPCIONES
		actualizar_seleccion_visual()
		get_viewport().set_input_as_handled()
		
	elif event.is_action_pressed("ui_menu_left"):
		opcion_actual = (opcion_actual - 1 + TOTAL_OPCIONES) % TOTAL_OPCIONES
		actualizar_seleccion_visual()
		get_viewport().set_input_as_handled()
		
	# Confirmar selección (usando "acción")
	elif event.is_action_pressed("acción"):
		ejecutar_opcion()
		get_viewport().set_input_as_handled()
		
	# Cancelar o salir (usando "correr" o "menu")
	elif event.is_action_pressed("correr") or event.is_action_pressed("menu"):
		_cerrar_pantalla()
		get_viewport().set_input_as_handled()

func actualizar_seleccion_visual() -> void:
	if not corazon_selector:
		return
		
	if opcion_actual == 0:
		corazon_selector.position = pos_corazon_guardar
	else:
		corazon_selector.position = pos_corazon_volver

func ejecutar_opcion() -> void:
	match opcion_actual:
		0: # Guardar
			if not ya_guardo:
				# 1. Guardamos la partida mediante el Autoload global
				GestorGuardado.guardar_partida()
				
				# 2. Cambiamos el NinePatchRect completo a color amarillo brillante
				if caja_guardado:
					caja_guardado.modulate = Color(1.0, 1.0, 0.0) 
					
					# Actualizamos el texto del Label para refrescar el tiempo y datos al guardar
					var label_texto = caja_guardado.get_node_or_null("Label")
					if label_texto and label_texto.has_method("actualizar_save"):
						label_texto.actualizar_save()
				
				# 3. Activamos la bandera para que la siguiente pulsación cierre la ventana
				ya_guardo = true
				
		1: # Volver
			_cerrar_pantalla()

func _cerrar_pantalla() -> void:
	# Restaurar los controles táctiles a la normalidad si se usó móvil/web
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios") or DisplayServer.is_touchscreen_available():
		if controles and controles.has_node("Control") and controles.has_node("Control3"):
			controles.get_node("Control").visible = true
			controles.get_node("Control3").visible = false

	# Devolvemos el movimiento al jugador al cerrar la pantalla
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		jugador.puede_moverse = true
		
	queue_free()
