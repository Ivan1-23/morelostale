extends Control

var opcion_actual: int = 0
const TOTAL_OPCIONES: int = 2

var ya_guardo: bool = false
var puede_cerrar_por_guardado: bool = false
var bloqueando_input: bool = true # Evita que registre la pulsación inicial de la estrella

@onready var corazon_selector: TextureRect = $NinePatchRect/TextureRect 
@onready var label_texto: Label = $NinePatchRect/name 
@onready var controles = get_tree().get_first_node_in_group("touch_ui")

@export var pos_corazon_guardar: Vector2 = Vector2(43, 210) 
@export var pos_corazon_volver: Vector2 = Vector2(270, 210)  

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios") or DisplayServer.is_touchscreen_available():
		if controles and controles.has_node("Control") and controles.has_node("Control3"):
			controles.get_node("Control").visible = false 
			controles.get_node("Control3").visible = true 

	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		jugador.puede_moverse = false
		
	actualizar_seleccion_visual()
	
	# Pequeña pausa inicial para ignorar el "Enter" o "Z" con el que abriste el menú
	await get_tree().create_timer(0.15).timeout
	bloqueando_input = false

func _input(event: InputEvent) -> void:
	if bloqueando_input:
		return

	# 1. Si ya se guardó y pasó el micro-tiempo de seguridad, cualquier botón cierra la pantalla
	if ya_guardo and puede_cerrar_por_guardado:
		if (event.is_action_pressed("acción") or event.is_action_pressed("correr") or event.is_action_pressed("menu") or event.is_action_pressed("ui_cancel")) and not event.is_echo():
			_cerrar_pantalla()
			get_viewport().set_input_as_handled()
		return

	# 2. Navegación hacia la derecha (Volver)
	if event.is_action_pressed("ui_menu_right"):
		opcion_actual = 1
		actualizar_seleccion_visual()
		get_viewport().set_input_as_handled()
		
	# 3. Navegación hacia la izquierda (Guardar)
	elif event.is_action_pressed("ui_menu_left"):
		opcion_actual = 0
		actualizar_seleccion_visual()
		get_viewport().set_input_as_handled()
		
	# 4. Confirmar selección con la tecla "acción"
	elif event.is_action_pressed("acción") and not event.is_echo():
		if opcion_actual == 0:
			if not ya_guardo:
				GestorGuardado.guardar_partida()
				if label_texto:
					label_texto.modulate = Color(1.0, 1.0, 0.0) 
					if label_texto.has_method("actualizar_save"):
						label_texto.actualizar_save()
				ya_guardo = true
				activar_seguridad_cierre()
		else:
			_cerrar_pantalla()
			
		get_viewport().set_input_as_handled()
		
	# 5. Salir o cancelar con "correr" o "menu"
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

func activar_seguridad_cierre() -> void:
	await get_tree().create_timer(0.25).timeout
	puede_cerrar_por_guardado = true

func _cerrar_pantalla() -> void:
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios") or DisplayServer.is_touchscreen_available():
		if controles and controles.has_node("Control") and controles.has_node("Control3"):
			controles.get_node("Control").visible = true
			controles.get_node("Control3").visible = false

	# Esperamos un instante antes de devolverle el movimiento y limpiar el menú, 
	# evitando que la misma pulsación dispare de nuevo la estrella del mapa.
	await get_tree().create_timer(0.15).timeout

	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		jugador.puede_moverse = true
		
	queue_free()
