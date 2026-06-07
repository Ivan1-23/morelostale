extends CanvasLayer

# Variables de nodos del menú
var texto_escribiendo = false
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
@onready var sonido_curacion = $sonido_curacion
@onready var sonido_squeak = $sonido_squeak
@onready var sonido_texto = $sonido_texto

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

# Añadidos nuevos estados para el control de la caja dimensional
enum ScreenLoaded {NOTHING, JUST_MENU, OBJECTO, ESTADISTICAS, TELEFONO, OBJETO2, INFO, CAJAa, CAJAb}
var screen_loaded = ScreenLoaded.NOTHING

var selected_option: int = 0
var selected_option2: int = 0
var selected_option3: int = 0

# === VARIABLES NUEVAS PARA CAJAS DIMENSIONALES ===
var caja_actual_referencia: Array = []

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
		if botonCerrar: botonCerrar.visible = false
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
	
	if sonido_cambio:
		sonido_cambio.stream = load("res://audio/Interfaz/undertale-select-sound.wav")
	if sonido_curacion:
		sonido_curacion.stream = load("res://audio/Interfaz/snd_heal_c.wav")
	if sonido_squeak:
		sonido_squeak.stream = load("res://audio/Interfaz/snd_squeak.wav")
	if sonido_texto:
		sonido_texto.stream = load("res://audio/voces/SND_TXT1.wav")

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

	var texto_gigante = $Control/NinePatchRect/objeto/VBoxContainer/RichTextLabel
	if texto_gigante and texto_gigante.has_method("actualizar_texto_inventario"):
		texto_gigante.actualizar_texto_inventario()

func abrir_desde_celular():
	if screen_loaded == ScreenLoaded.NOTHING:
		menu.visible = true
		
		# === ¡CORREGIDO AQUÍ! ===
		# Cambiamos 'botonCerrar = true' por la propiedad correcta '.visible' para no romper el nodo
		if botonCerrar:
			botonCerrar.visible = DisplayServer.is_touchscreen_available()
			
		objetos.visible = false
		estadisticas.visible = false
		telefono.visible = false
		info.visible = false
		select_arrow.visible = true
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
		var mini_stats = $Control/mini_stats/VBoxContainer/MiniStatsLabel
		if mini_stats and mini_stats.has_method("actualizar_mini_stats"):
			mini_stats.actualizar_mini_stats()

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
			
		# Regresar desde las interfaces de las cajas dimensionales al panel Teléfono
		ScreenLoaded.CAJAa, ScreenLoaded.CAJAb:
			# Aquí ocultas visualmente tus paneles de caja si los tienes
			telefono.visible = true
			selected_option2 = 0
			select_arrow.position = Vector2(select_x2, select_y2)
			screen_loaded = ScreenLoaded.TELEFONO

func _input(event):
	match screen_loaded:
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu"):
				if sonido_squeak: sonido_squeak.play()
				abrir_desde_celular()
				selected_option = 0
				select_arrow.visible = true
				select_arrow.position = Vector2(select_x, select_y)

		ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_squeak: sonido_squeak.play()
				regresar_un_paso_atras()
			
			elif event.is_action_pressed("ui_menu_down"):
				if sonido_squeak: sonido_squeak.play()
				selected_option = (selected_option + 1) % 3
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			elif event.is_action_pressed("ui_menu_up"):
				if sonido_squeak: sonido_squeak.play()
				selected_option = (selected_option - 1 + 3) % 3
				select_arrow.position = Vector2(select_x, select_y + selected_option * px_d)
				
			elif event.is_action_pressed("acción") and selected_option == 0:
				if sonido_cambio: sonido_cambio.play()
				_on_boton_objeto_pressed()
			elif event.is_action_pressed("acción") and selected_option == 1:
				if sonido_cambio: sonido_cambio.play()
				_on_boton_estadisticas_pressed()
				var label_stats = $Control/NinePatchRect/Estadisticas/VBoxContainer/stats
				if label_stats and label_stats.has_method("actualizar_estadisticas"):
					label_stats.actualizar_estadisticas()
			elif event.is_action_pressed("acción") and selected_option == 2:
				if sonido_cambio: sonido_cambio.play()
				_on_boton_telefono_pressed()

		ScreenLoaded.OBJECTO:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_cambio: sonido_cambio.play()
				regresar_un_paso_atras()
			
			elif event.is_action_pressed("ui_menu_down") and selected_option2 < diccionario_global.inventario.size() - 1:
				if sonido_squeak: sonido_squeak.play()
				selected_option2 += 1
				select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
			elif event.is_action_pressed("ui_menu_up") and selected_option2 > 0:
				if sonido_squeak: sonido_squeak.play()
				selected_option2 -= 1
				select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
				
			elif event.is_action_pressed("acción"):
				if selected_option2 < diccionario_global.inventario.size() and diccionario_global.inventario.size() > 0:
					if sonido_cambio: sonido_cambio.play()
					select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
					screen_loaded = ScreenLoaded.OBJETO2

		ScreenLoaded.OBJETO2:
			if event.is_action_pressed("correr") or event.is_action_pressed("menu"):
				if sonido_cambio: sonido_cambio.play()
				cerrar_todo_el_menu_de_golpe()
				
			elif event.is_action_pressed("acción") and selected_option3 == 0:
				_on_boton_usar_pressed()
			elif event.is_action_pressed("acción") and selected_option3 == 1:
				_on_boton_info_pressed()
			elif event.is_action_pressed("acción") and selected_option3 == 2:
				_on_boton_tirar_pressed()
				
			elif event.is_action_pressed("ui_menu_right"):
				if sonido_squeak: sonido_squeak.play()
				selected_option3 = (selected_option3 + 1) % 3
				select_arrow.position = Vector2(select_x2 + selected_option3 * 105, 184)
				
			elif event.is_action_pressed("ui_menu_left"):
				if sonido_squeak: sonido_squeak.play()
				selected_option3 = (selected_option3 - 1 + 3) % 3
				select_arrow.position = Vector2(select_x2 + selected_option3 * 105, 184)

		ScreenLoaded.INFO:
			if event.is_action_pressed("correr") or event.is_action_pressed("acción"):
				texto_escribiendo = false
				if sonido_texto: 
					sonido_texto.stop()
				cerrar_todo_el_menu_de_golpe()

		ScreenLoaded.ESTADISTICAS:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_cambio: sonido_cambio.play()
				regresar_un_paso_atras()

		# === LOGICA DE NAVEGACION PARA CAJAS EN PANEL TELEFONO ===
		ScreenLoaded.TELEFONO:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_cambio: sonido_cambio.play()
				regresar_un_paso_atras()
			
			# Mover verticalmente entre 0 (Caja A) y 1 (Caja B)
			elif event.is_action_pressed("ui_menu_down") and selected_option2 < 1:
				if sonido_squeak: sonido_squeak.play()
				selected_option2 += 1
				select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
			elif event.is_action_pressed("ui_menu_up") and selected_option2 > 0:
				if sonido_squeak: sonido_squeak.play()
				selected_option2 -= 1
				select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
				
			# Seleccionar qué caja dimensional abrir presionando Z / Acción
			elif event.is_action_pressed("acción"):
				if sonido_cambio: sonido_cambio.play()
				if selected_option2 == 0:
					abrir_interfaz_caja(ScreenLoaded.CAJAa)
				else:
					abrir_interfaz_caja(ScreenLoaded.CAJAb)

		# Control interno de las cajas (Puedes expandir esto según tus paneles visuales)
		ScreenLoaded.CAJAa, ScreenLoaded.CAJAb:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_cambio: sonido_cambio.play()
				regresar_un_paso_atras()

func cerrar_todo_el_menu_de_golpe():
	menu.visible = false
	objetos.visible = false
	estadisticas.visible = false
	telefono.visible = false
	info.visible = false
	select_arrow.visible = false
	if botonCerrar: botonCerrar.visible = false
	
	if controls:
		controls.visible = true
		controls.process_mode = PROCESS_MODE_INHERIT
	
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		jugador.puede_moverse = true
		if jugador.has_method("set_physics_process"):
			jugador.set_physics_process(true)
	
	selected_option = 0
	selected_option2 = 0
	selected_option3 = 0
	screen_loaded = ScreenLoaded.NOTHING

# --- LOGICA LOGICA DEL SISTEMA DE CAJAS DIMENSIONALES ---
func abrir_interfaz_caja(tipo_caja):
	screen_loaded = tipo_caja
	selected_option3 = 0 # 0 = Modo Guardar, 1 = Modo Retirar
	
	if tipo_caja == ScreenLoaded.CAJAa:
		caja_actual_referencia = diccionario_global.caja_a
		print("--- CAJA DIMENSIONAL A ABIERTA ---")
	else:
		caja_actual_referencia = diccionario_global.caja_b
		print("--- CAJA DIMENSIONAL B ABIERTA ---")
		
	# Aquí harías visible el panel específico de las cajas si cuentas con él
	actualizar_visualizacion_caja()

func guardar_objeto_en_caja(indice_inventario: int):
	if diccionario_global.inventario.size() > indice_inventario:
		if caja_actual_referencia.size() < diccionario_global.MAX_ESPACIO_CAJA:
			var id_item = diccionario_global.inventario[indice_inventario]
			
			caja_actual_referencia.append(id_item)
			diccionario_global.eliminar_objeto_por_indice(indice_inventario)
			
			actualizar_visualizacion_inventario()
			actualizar_visualizacion_caja()
			if sonido_cambio: sonido_cambio.play()
		else:
			print("La caja dimensional está llena.")

func retirar_objeto_de_caja(indice_caja: int):
	if caja_actual_referencia.size() > indice_caja:
		if diccionario_global.inventario.size() < 8:
			var id_item = caja_actual_referencia[indice_caja]
			
			diccionario_global.añadir_objeto(id_item)
			caja_actual_referencia.remove_at(indice_caja)
			
			actualizar_visualizacion_inventario()
			actualizar_visualizacion_caja()
			if sonido_cambio: sonido_cambio.play()
		else:
			print("No puedes cargar más objetos, inventario lleno.")

func actualizar_visualizacion_caja():
	# En esta función puedes mapear las etiquetas de texto de la interfaz de la caja
	# recorriendo los IDs almacenados en 'caja_actual_referencia'
	pass

# --- SEÑALES Y BOTONES ---
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
	
	var label_stats = $Control/NinePatchRect/Estadisticas/VBoxContainer/stats
	if label_stats and label_stats.has_method("actualizar_estadisticas"):
		label_stats.actualizar_estadisticas()
		
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
		var id_item_nuevo = diccionario_global.inventario[selected_option2]
		var datos_item = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item_nuevo, {})
		var tipo_objeto = datos_item.get("tipo", "")
		var nombre_objeto = datos_item.get("nombre", "Desconocido")
		
		var mensaje = ""
		var es_equipable = false
		
		if tipo_objeto == "objeto curativo" or tipo_objeto == "objetivo curativo":
			es_equipable = true
			var puntos_curacion = datos_item.get("hp", 0)
			
			if sonido_curacion:
				sonido_curacion.play()
			
			if Global.vida >= Global.vidaMax:
				mensaje = "* Tu HP ya está al máximo."
			else:
				Global.vida += puntos_curacion
				if Global.vida >= Global.vidaMax:
					Global.vida = Global.vidaMax
					mensaje = "* Tus HP subieron al máximo."
				else:
					mensaje = "* Recuperaste " + str(puntos_curacion) + " HP."
				diccionario_global.eliminar_objeto_por_indice(selected_option2)
			
		elif tipo_objeto == "Arma":
			es_equipable = true
			if sonido_cambio:
				sonido_cambio.stream = load("res://audio/Interfaz/snd_item.wav")
				sonido_cambio.play()
			
			var id_arma_vieja = Global.arma_equipada
			Global.arma_equipada = id_item_nuevo
			mensaje = "* Te equipaste " + nombre_objeto + "."
			diccionario_global.eliminar_objeto_por_indice(selected_option2)
			
			if id_arma_vieja != "" and id_arma_vieja != "Ninguna":
				diccionario_global.añadir_objeto(id_arma_vieja)
			if Global.has_method("actualizar_equipamiento"):
				Global.actualizar_equipamiento()
				
			sonido_cambio.stream = load("res://audio/Interfaz/undertale-select-sound.wav")
				
		elif tipo_objeto == "Armadura":
			es_equipable = true
			if sonido_cambio:
				sonido_cambio.stream = load("res://audio/Interfaz/snd_item.wav")
				sonido_cambio.play()
			
			var id_armadura_vieja = Global.armadura_equipada
			Global.armadura_equipada = id_item_nuevo
			mensaje = "* Te equipaste " + nombre_objeto + "."
			diccionario_global.eliminar_objeto_por_indice(selected_option2)
			
			if id_armadura_vieja != "" and id_armadura_vieja != "Ninguna":
				diccionario_global.añadir_objeto(id_armadura_vieja)
			if Global.has_method("actualizar_equipamiento"):
				Global.actualizar_equipamiento()
				
			sonido_cambio.stream = load("res://audio/Interfaz/undertale-select-sound.wav")

		if es_equipable:
			mostrar_texto_animado(mensaje)
			actualizar_visualizacion_inventario()
			var mini_stats = $Control/mini_stats/VBoxContainer/MiniStatsLabel
			if mini_stats and mini_stats.has_method("actualizar_mini_stats"):
				mini_stats.actualizar_mini_stats()
			var label_stats = $Control/NinePatchRect/Estadisticas/VBoxContainer/stats
			if label_stats and label_stats.has_method("actualizar_estadisticas"):
				label_stats.actualizar_estadisticas()
		else:
			screen_loaded = ScreenLoaded.NOTHING
			menu.visible = false; objetos.visible = false; info.visible = false; select_arrow.visible = false

func _on_boton_info_pressed():
	if screen_loaded == ScreenLoaded.OBJETO2:
		var id_item = diccionario_global.inventario[selected_option2]
		var datos_item = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item, {})
		var descripcion = datos_item.get("descripcion", "* No hay informacion disponible.")
		mostrar_texto_animado(descripcion)

func _on_boton_tirar_pressed():
	if screen_loaded == ScreenLoaded.OBJETO2:
		var id_item = diccionario_global.inventario[selected_option2]
		var datos_item = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item, {})
		var nombre_objeto = datos_item.get("nombre", "Objeto")
		
		diccionario_global.eliminar_objeto_por_indice(selected_option2)
		mostrar_texto_animado("* El " + nombre_objeto + " ha sido desechado.")
		actualizar_visualizacion_inventario()
		
		var mini_stats = $Control/NinePatchRect/MiniStatsLabel
		if mini_stats and mini_stats.has_method("actualizar_mini_stats"):
			mini_stats.actualizar_mini_stats()

# --- REPRODUCCIÓN AUDIO ---
func reproducir_sonido_seleccion():
	if sonido_cambio:
		if sonido_cambio.stream:
			sonido_cambio.play()
		else:
			sonido_cambio.stream = load("res://audio/Interfaz/undertale-select-sound.wav")
			sonido_cambio.play()

func mostrar_texto_animado(texto_completo: String):
	var label_info = info.get_node_or_null("Label")
	if not label_info:
		return
		
	label_info.text = "" 
	menu.visible = false
	info.visible = true
	select_arrow.visible = false
	screen_loaded = ScreenLoaded.INFO
	
	# === ENCIENDE LOS CONTROLES TÁCTILES DEL MAPA AQUÍ ===
	if controls:
		controls.visible = true
		controls.process_mode = PROCESS_MODE_INHERIT
	
	texto_escribiendo = true
	
	for i in range(texto_completo.length()):
		if not texto_escribiendo:
			break
		label_info.text += texto_completo[i]
		if texto_completo[i] != " " and sonido_texto:
			sonido_texto.play()
		await get_tree().create_timer(0.04).timeout

	texto_escribiendo = false
	if sonido_texto:
		sonido_texto.stop()
