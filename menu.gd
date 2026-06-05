extends CanvasLayer

# Variables de nodos del menú
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

# Sonido de cambio de interfaz
@onready var sonido_cambio = $sonido_cambio

# Tu botón inteligente de la esquina para cerrar/volver
@onready var botonCerrar = $Control/BotonCerrar

@onready var controls = get_tree().current_scene.find_child("touch_button", true, false) if is_inside_tree() else null

# Variables de posicionamiento del corazón
var select_x = 28
var select_y = 35
var px_d = 33

# Ajustado select_y2 a -70
var select_x2 = 176
var select_y2 = -70

enum ScreenLoaded {NOTHING, JUST_MENU, OBJECTO, ESTADISTICAS, TELEFONO, OBJETO2, INFO, CAJAa, CAJAb}
var screen_loaded = ScreenLoaded.NOTHING

var selected_option: int = 0
var selected_option2: int = 0
var selected_option3: int = 0

func _ready():
	add_to_group("menu_sistema")
	
	menu.visible = false
	objetos.visible = false
	estadisticas.visible = false
	telefono.visible = false
	info.visible = false
	
	select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
	
	if menu:
		menu.mouse_filter = Control.MOUSE_FILTER_PASS
	
	if not DisplayServer.is_touchscreen_available():
		botonCerrar.visible = false
		botonObjeto.visible = false
		botonEstadisticas.visible = false
		botonTelefono.visible = false
		botonItem1.visible = false
		botonItem2.visible = false
		botonItem3.visible = false
		botonItem4.visible = false
		botonItem5.visible = false
		botonItem6.visible = false
		botonItem7.visible = false
		botonItem8.visible = false
		botonUsar.visible = false
		botonInfo.visible = false
		botonCerrar.visible = false

# --- FUNCIÓN: ACTUALIZA LOS BOTONES CON EL INVENTARIO REAL ---
func actualizar_visualizacion_inventario():
	var lista_botones = [botonItem1, botonItem2, botonItem3, botonItem4, botonItem5, botonItem6, botonItem7, botonItem8]
	var tamano_inventario = diccionario_global.inventario.size()
	
	for i in range(8):
		if i < tamano_inventario:
			var id_item = diccionario_global.inventario[i]
			var datos_item = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item, {})
			
			lista_botones[i].text = datos_item.get("nombre", "Desconocido")
			lista_botones[i].visible = true
		else:
			lista_botones[i].text = ""
			lista_botones[i].visible = false

func abrir_desde_celular():
	if screen_loaded == ScreenLoaded.NOTHING:
		menu.visible = true
		objetos.visible = false
		estadisticas.visible = false
		telefono.visible = false
		info.visible = false
		select_arrow.visible = true
		botonCerrar.visible = true 
		screen_loaded = ScreenLoaded.JUST_MENU
		
		var jugador = get_tree().get_first_node_in_group("player")
		if jugador:
			jugador.puede_moverse = false
			var anim_actual = jugador.animaciones.animation
			var direccion = "down"
			if "right" in anim_actual: direccion = "right"
			elif "left" in anim_actual: direccion = "left"
			elif "top" in anim_actual: direccion = "top"
			jugador.animaciones.play("idle_" + direccion)
			
		if not controls:
			controls = get_tree().current_scene.find_child("touch_button", true, false)
		if controls:
			controls.visible = false
			controls.process_mode = PROCESS_MODE_DISABLED

func regresar_un_paso_atras():
	match screen_loaded:
		ScreenLoaded.JUST_MENU:
			menu.visible = false
			screen_loaded = ScreenLoaded.NOTHING
			selected_option = 0
			select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			select_arrow.visible = true
			
			var jugador = get_tree().get_first_node_in_group("player")
			if jugador:
				jugador.puede_moverse = true
			if controls:
				controls.visible = true
				controls.process_mode = PROCESS_MODE_INHERIT
				
		ScreenLoaded.OBJECTO, ScreenLoaded.ESTADISTICAS, ScreenLoaded.TELEFONO:
			objetos.visible = false
			estadisticas.visible = false
			telefono.visible = false
			info.visible = false
			select_arrow.visible = true
			select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			screen_loaded = ScreenLoaded.JUST_MENU
			
		ScreenLoaded.OBJETO2:
			screen_loaded = ScreenLoaded.OBJECTO
			select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
			
		ScreenLoaded.INFO:
			info.visible = false
			select_arrow.visible = true
			objetos.visible = true
			select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
			screen_loaded = ScreenLoaded.OBJETO2

func _input(event):
	# --- CONTROL DE AUDIO SEGURO ---
	if screen_loaded != ScreenLoaded.NOTHING:
		if event.is_action_pressed("menu") or event.is_action_pressed("correr") or event.is_action_pressed("acción"):
			reproducir_sonido_seleccion()
	else:
		if event.is_action_pressed("menu"):
			reproducir_sonido_seleccion()

	match screen_loaded:
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu"):
				abrir_desde_celular()

		ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				regresar_un_paso_atras()
			elif event.is_action_pressed("ui_menu_down"):
				selected_option += 1
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			elif event.is_action_pressed("ui_menu_up"):
				if selected_option == 0:
					select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
				else:
					selected_option -= 1
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			elif event.is_action_pressed("acción") and selected_option == 0:
				_on_boton_objeto_pressed()
			elif event.is_action_pressed("acción") and selected_option == 1:
				_on_boton_estadisticas_pressed()
			elif event.is_action_pressed("acción") and selected_option == 2:
				_on_boton_telefono_pressed()

		ScreenLoaded.OBJECTO:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				regresar_un_paso_atras()
			elif event.is_action_pressed("ui_menu_down") and selected_option2 < diccionario_global.inventario.size() - 1:
				selected_option2 += 1
				select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
			elif event.is_action_pressed("ui_menu_up") and selected_option2 > 0:
				selected_option2 -= 1
				select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
			elif event.is_action_pressed("acción"):
				if selected_option2 < diccionario_global.inventario.size():
					select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
					screen_loaded = ScreenLoaded.OBJETO2

		ScreenLoaded.OBJETO2:
			if event.is_action_pressed("correr") or event.is_action_pressed("menu"):
				regresar_un_paso_atras()
			elif event.is_action_pressed("acción") and selected_option3 == 0:
				_on_boton_usar_pressed()
			elif event.is_action_pressed("acción") and selected_option3 == 1:
				_on_boton_info_pressed()
			elif event.is_action_pressed("acción") and selected_option3 == 2:
				_on_boton_tirar_pressed()
			elif event.is_action_pressed("ui_menu_right"):
				selected_option3 += 1
				select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
			elif event.is_action_pressed("ui_menu_left"):
				if selected_option3 == 0:
					select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
				else:
					selected_option3 -= 1
				select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)

		ScreenLoaded.INFO:
			if event.is_action_pressed("acción") or event.is_action_pressed("correr") or event.is_action_pressed("menu"):
				regresar_un_paso_atras()

		ScreenLoaded.ESTADISTICAS, ScreenLoaded.TELEFONO:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				regresar_un_paso_atras()

# --- SEÑAL DEL BOTÓN TÁCTIL "Y" ---
func _on_boton_y_pressed() -> void:
	reproducir_sonido_seleccion()
	var jugador = get_tree().get_first_node_in_group("player")
	if menu.visible:
		menu.visible = false
		info.visible = false
		screen_loaded = ScreenLoaded.NOTHING
		if jugador:
			jugador.puede_moverse = true
	else:
		if jugador and jugador.puede_moverse:
			menu.visible = true
			info.visible = false
			jugador.puede_moverse = false
			screen_loaded = ScreenLoaded.JUST_MENU
			selected_option = 0
			select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			get_viewport().set_input_as_handled()

# --- SEÑAL DEL BOTÓN "ATRÁS" (CERRAR EN LA ESQUINA) ---
func _on_boton_cerrar_pressed() -> void:
	reproducir_sonido_seleccion()
	var estado_antes = screen_loaded
	regresar_un_paso_atras()
	
	if estado_antes == ScreenLoaded.JUST_MENU:
		menu.visible = false
		info.visible = false
		screen_loaded = ScreenLoaded.NOTHING
		
		var jugador = get_tree().get_first_node_in_group("player")
		if jugador:
			jugador.puede_moverse = true
		if controls:
			controls.visible = true
			controls.process_mode = PROCESS_MODE_INHERIT

# --- BOTONES TÁCTILES PRINCIPALES ---
func _on_boton_objeto_pressed():
	reproducir_sonido_seleccion()
	actualizar_visualizacion_inventario()
	
	selected_option = 0
	selected_option2 = 0
	select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
	objetos.visible = true
	estadisticas.visible = false
	telefono.visible = false
	info.visible = false
	select_arrow.visible = true
	select_arrow.position = Vector2(select_x2, select_y2)
	screen_loaded = ScreenLoaded.OBJECTO

func _on_boton_estadisticas_pressed():
	reproducir_sonido_seleccion()
	selected_option = 1
	select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
	objetos.visible = false
	estadisticas.visible = true
	telefono.visible = false
	info.visible = false
	screen_loaded = ScreenLoaded.ESTADISTICAS

func _on_boton_telefono_pressed():
	reproducir_sonido_seleccion()
	selected_option = 2
	select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
	objetos.visible = false
	estadisticas.visible = false
	telefono.visible = true
	info.visible = false
	screen_loaded = ScreenLoaded.TELEFONO

# --- SELECCIÓN DE ITEMS TÁCTILES ---
func _on_boton_item_1_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO and diccionario_global.inventario.size() > 0:
		reproducir_sonido_seleccion()
		selected_option2 = 0
		selected_option3 = 0
		select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_2_pressed():
	if screen_loaded == ScreenLoaded.OBJECTO and diccionario_global.inventario.size() > 1:
		reproducir_sonido_seleccion()
		selected_option2 = 1
		selected_option3 = 0
		select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_3_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO and diccionario_global.inventario.size() > 2:
		reproducir_sonido_seleccion()
		selected_option2 = 2
		selected_option3 = 0
		select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_4_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO and diccionario_global.inventario.size() > 3:
		reproducir_sonido_seleccion()
		selected_option2 = 3
		selected_option3 = 0
		select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_5_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO and diccionario_global.inventario.size() > 4:
		reproducir_sonido_seleccion()
		selected_option2 = 4
		selected_option3 = 0
		select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_6_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO and diccionario_global.inventario.size() > 5:
		reproducir_sonido_seleccion()
		selected_option2 = 5
		selected_option3 = 0
		select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_7_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO and diccionario_global.inventario.size() > 6:
		reproducir_sonido_seleccion()
		selected_option2 = 6
		selected_option3 = 0
		select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_8_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO and diccionario_global.inventario.size() > 7:
		reproducir_sonido_seleccion()
		selected_option2 = 7
		selected_option3 = 0
		select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

# --- ACCIONES DE LOS ITEMS ---
func _on_boton_usar_pressed():
	if screen_loaded == ScreenLoaded.OBJETO2:
		reproducir_sonido_seleccion()
		
		var id_item = diccionario_global.inventario[selected_option2]
		var datos_item = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item, {})
		
		print("Usaste: ", datos_item.get("nombre"))
		
		if datos_item.get("tipo") == "objeto curativo" or datos_item.get("tipo") == "objetivo curativo":
			diccionario_global.eliminar_objeto_por_indice(selected_option2)
		
		screen_loaded = ScreenLoaded.JUST_MENU
		regresar_un_paso_atras()

func _on_boton_info_pressed():
	if screen_loaded == ScreenLoaded.OBJETO2:
		reproducir_sonido_seleccion()
		selected_option3 = 1
		select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
		
		if selected_option2 < diccionario_global.inventario.size():
			var id_item = diccionario_global.inventario[selected_option2]
			var datos_item = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item, {})
			
			var label_info = info.get_node_or_null("Label")
			if label_info:
				label_info.text = datos_item.get("descripcion", "* No hay información disponible.")
		objetos.visible = false
		estadisticas.visible = false
		telefono.visible = false
		select_arrow.visible = false
		info.visible = true
		screen_loaded = ScreenLoaded.INFO

func _on_boton_tirar_pressed():
	if screen_loaded == ScreenLoaded.OBJETO2:
		reproducir_sonido_seleccion()
		
		diccionario_global.eliminar_objeto_por_indice(selected_option2)
		
		screen_loaded = ScreenLoaded.JUST_MENU
		regresar_un_paso_atras()

# --- FUNCIÓN DE AUDIO ---
func reproducir_sonido_seleccion():
	if sonido_cambio:
		if sonido_cambio.stream:
			sonido_cambio.play()
		else:
			sonido_cambio.stream = load("res://audio/Interfaz/undertale-select-sound.wav")
			sonido_cambio.play()
