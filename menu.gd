extends CanvasLayer

# --- NUEVA REFERENCIA DE AUDIO ---
@onready var sonido_cambio = $sonido_cambio

# Variables de nodos del menú (Tus nodos originales intactos)
@onready var select_arrow = $Control/NinePatchRect/TextureRect
@onready var menu = $Control
@onready var objetos = $Control/NinePatchRect/objeto
@onready var estadisticas = $Control/NinePatchRect/Estadisticas
@onready var telefono = $Control/NinePatchRect/Telefono
@onready var info = $Control2/info
@onready var botonObjeto = $Control/NinePatchRect/BotonObjeto
@onready var botonEstadisticas = $Control/NinePatchRect/BotonEstadisticas
@onready var botonTelefono = $Control/NinePatchRect/BotonTelefono
@onready var botonItem1 = $Control/NinePatchRect/objeto/BotonItem1
@onready var botonItem2 = $Control/NinePatchRect/objeto/BotonItem2
@onready var botonItem3 = $Control/NinePatchRect/objeto/BotonItem3
@onready var botonItem4 = $Control/NinePatchRect/objeto/BotonItem4
@onready var botonItem5 = $Control/NinePatchRect/objeto/BotonItem5
@onready var botonItem6 = $Control/NinePatchRect/objeto/BotonItem6
@onready var botonItem7 = $Control/NinePatchRect/objeto/BotonItem7
@onready var botonItem8 = $Control/NinePatchRect/objeto/BotonItem8
@onready var botonUsar = $Control/NinePatchRect/objeto/BotonUsar
@onready var botonInfo = $Control/NinePatchRect/objeto/BotonInfo
@onready var botonTirar = $Control/NinePatchRect/objeto/BotonTirar

enum ScreenLoaded {
	NOTHING,          # Menú completamente cerrado y oculto
	JUST_MENU,        # Tu estado original de Undertale (ITEM, STAT, CELL)
	OBJECTO,          # Lista de los 8 objetos abiertos
	OBJETO2,          # Sub-menú inferior (USAR, INFO, TIRAR)
	ESTADISTICAS,     # Pantalla de estadísticas
	TELEFONO          # Pantalla de teléfono
}

var screen_loaded = ScreenLoaded.NOTHING
var selected_option = 0
var selected_option2 = 0
var selected_option3 = 0

func _ready() -> void:
	select_arrow.position = Vector2(42, 51)
	menu.visible = false
	objetos.visible = false
	estadisticas.visible = false
	telefono.visible = false
	info.visible = false
	screen_loaded = ScreenLoaded.NOTHING

func _input(event) -> void:
	# Abrir o Cerrar menú principal en PC (Teclado)
	if event.is_action_pressed("menu"):
		var jugador = get_tree().get_first_node_in_group("player")
		if menu.visible:
			menu.visible = false
			info.visible = false
			screen_loaded = ScreenLoaded.NOTHING
			reproducir_sonido_seleccion()
			if jugador:
				jugador.puede_moverse = true
		else:
			if jugador and jugador.puede_moverse:
				menu.visible = true
				info.visible = true
				jugador.puede_moverse = false
				screen_loaded = ScreenLoaded.JUST_MENU
				selected_option = 0
				select_arrow.position = Vector2(42, 51)
				reproducir_sonido_seleccion()

	# Si el menú está abierto, procesamos las interacciones físicas
	if menu.visible:
		# --- ACCIÓN GLOBAL DE VOLVER ATRÁS (Botón X / "atrás") ---
		if event.is_action_pressed("atrás"):
			if screen_loaded == ScreenLoaded.OBJECTO:
				screen_loaded = ScreenLoaded.JUST_MENU
				objetos.visible = false
				select_arrow.position = Vector2(42, 51 + selected_option * 36)
				reproducir_sonido_seleccion()
			elif screen_loaded == ScreenLoaded.OBJETO2:
				screen_loaded = ScreenLoaded.OBJECTO
				select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
				reproducir_sonido_seleccion()
			elif screen_loaded == ScreenLoaded.ESTADISTICAS:
				screen_loaded = ScreenLoaded.JUST_MENU
				estadisticas.visible = false
				select_arrow.position = Vector2(42, 51 + selected_option * 36)
				reproducir_sonido_seleccion()
			elif screen_loaded == ScreenLoaded.TELEFONO:
				screen_loaded = ScreenLoaded.JUST_MENU
				telefono.visible = false
				select_arrow.position = Vector2(42, 51 + selected_option * 36)
				reproducir_sonido_seleccion()

		# --- PANTALLA: MENÚ PRINCIPAL (JUST_MENU) ---
		if screen_loaded == ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("ui_down") and selected_option < 2:
				selected_option += 1
				select_arrow.position = Vector2(42, 51 + selected_option * 36)
				reproducir_sonido_seleccion()
			elif event.is_action_pressed("ui_up") and selected_option > 0:
				selected_option -= 1
				select_arrow.position = Vector2(42, 51 + selected_option * 36)
				reproducir_sonido_seleccion()
			elif event.is_action_pressed("acción"):
				reproducir_sonido_seleccion()
				if selected_option == 0:
					screen_loaded = ScreenLoaded.OBJECTO
					objetos.visible = true
					selected_option2 = 0
					select_arrow.position = Vector2(176, -70)
				elif selected_option == 1:
					screen_loaded = ScreenLoaded.ESTADISTICAS
					estadisticas.visible = true
				elif selected_option == 2:
					screen_loaded = ScreenLoaded.TELEFONO
					telefono.visible = true

		# --- PANTALLA: SELECCIÓN DE OBJETO (LISTA DE 8) ---
		elif screen_loaded == ScreenLoaded.OBJECTO:
			if event.is_action_pressed("ui_down") and selected_option2 < 7:
				selected_option2 += 1
				select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
				reproducir_sonido_seleccion()
			elif event.is_action_pressed("ui_up") and selected_option2 > 0:
				selected_option2 -= 1
				select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
				reproducir_sonido_seleccion()
			elif event.is_action_pressed("acción"):
				reproducir_sonido_seleccion()
				screen_loaded = ScreenLoaded.OBJETO2
				selected_option3 = 0
				select_arrow.position = Vector2(176, 184)

		# --- PANTALLA: SUB-OPCIONES DE OBJETO (USAR, INFO, TIRAR) ---
		elif screen_loaded == ScreenLoaded.OBJETO2:
			if event.is_action_pressed("ui_right") and selected_option3 < 2:
				selected_option3 += 1
				select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
				reproducir_sonido_seleccion()
			elif event.is_action_pressed("ui_left") and selected_option3 > 0:
				selected_option3 -= 1
				select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
				reproducir_sonido_seleccion()
			elif event.is_action_pressed("acción"):
				reproducir_sonido_seleccion()


# ==============================================================================
# --- SEÑALES DE LOS BOTONES TÁCTILES (CELULAR) ---
# ==============================================================================

# --- NUEVA FUNCIÓN DEL BOTÓN VIRTUAL Y (Soluciona el bug en celular) ---
func _on_boton_y_pressed() -> void:
	var jugador = get_tree().get_first_node_in_group("player")
	
	if menu.visible:
		menu.visible = false
		info.visible = false
		screen_loaded = ScreenLoaded.NOTHING
		reproducir_sonido_seleccion()
		if jugador:
			jugador.puede_moverse = true
	else:
		if jugador and jugador.puede_moverse:
			menu.visible = true
			info.visible = true
			jugador.puede_moverse = false
			screen_loaded = ScreenLoaded.JUST_MENU
			selected_option = 0
			select_arrow.position = Vector2(42, 51)
			reproducir_sonido_seleccion()
			
			# Informamos a Godot que este toque se resolvió aquí de manera aislada
			get_viewport().set_input_as_handled()

func _on_boton_objeto_pressed() -> void:
	if screen_loaded == ScreenLoaded.JUST_MENU:
		selected_option = 0
		select_arrow.position = Vector2(42, 51)
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.OBJECTO
		objetos.visible = true
		selected_option2 = 0
		select_arrow.position = Vector2(176, -70)

func _on_boton_estadisticas_pressed() -> void:
	if screen_loaded == ScreenLoaded.JUST_MENU:
		selected_option = 1
		select_arrow.position = Vector2(42, 87)
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.ESTADISTICAS
		estadisticas.visible = true

func _on_boton_telefono_pressed() -> void:
	if screen_loaded == ScreenLoaded.JUST_MENU:
		selected_option = 2
		select_arrow.position = Vector2(42, 123)
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.TELEFONO
		telefono.visible = true

# --- BOTONES DE LA LISTA DE ÍTEMS ---
# Corregido: Colocan el corazón en el ítem actual usando tus matemáticas de origen

func _on_boton_item_1_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 0
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_2_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 1
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_3_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 2
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_4_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 3
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_5_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 4
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_6_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 5
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_7_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 6
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_8_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 7
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		reproducir_sonido_seleccion()
		screen_loaded = ScreenLoaded.OBJETO2

# --- BOTONES DE SUB-OPCIONES (CELULAR) ---
func _on_boton_usar_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJETO2:
		reproducir_sonido_seleccion()

func _on_boton_info_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJETO2:
		reproducir_sonido_seleccion()

func _on_boton_tirar_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJETO2:
		reproducir_sonido_seleccion()

# --- EL BOTÓN CERRAR (Elimina la advertencia roja del editor) ---
func _on_boton_cerrar_pressed() -> void:
	var jugador = get_tree().get_first_node_in_group("player")
	if menu.visible:
		menu.visible = false
		info.visible = false
		screen_loaded = ScreenLoaded.NOTHING
		reproducir_sonido_seleccion()
		if jugador:
			jugador.puede_moverse = true

# --- FUNCIÓN AUXILIAR DE AUDIO ---
func reproducir_sonido_seleccion():
	if sonido_cambio:
		sonido_cambio.play()
