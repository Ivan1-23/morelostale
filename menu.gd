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
@onready var lista_inventario = $Control/NinePatchRect/objeto/ListaInventario
@onready var interfaz_caja = $Control/NinePatchRect/InterfazCaja
@onready var botonCerrar = $Control/BotonCerrar
@onready var titulo_caja_label = $Control/NinePatchRect/InterfazCaja/TituloCaja2
@onready var texto_indicador = $Control/NinePatchRect/InterfazCaja/TextoIndicador
@onready var lista_caja_inventario = $Control/NinePatchRect/InterfazCaja/ContenedorColumnas/ListaInventario
@onready var lista_caja_dimensional = $Control/NinePatchRect/InterfazCaja/ContenedorColumnas/ListaCaja
# Variables de Audio
@onready var sonido_cambio = $sonido_cambio
@onready var sonido_squeak = $sonido_squeak
@onready var sonido_texto = $sonido_texto
@onready var sonido_curacion = $sonido_curacion

# Variables de posicionamiento de la flecha
var select_x = 29
var select_x2 = 175
var px_d = 33
var select_y = 35
var select_y2 = -70
var selected_option = 0
var selected_option2 = 0
var selected_option3 = 0

# Coordenadas para que el corazón indique el personaje en la pantalla de selección/stats
var select_x_stats = 45 
var select_y_stats = [60, 95, 130]
# === VARIABLES NUEVAS PARA CONTROL DE TELÉFONO Y CAJAS ===
var selected_option_telefono: int = 0  # Controla la selección en la pantalla del teléfono
var caja_actual_referencia: Array = []  # Guarda dinámicamente si usamos caja_a o caja_b

# (Asegúrate de tener también declaradas estas variables de posición si no las tenías)
var caja_pos_x_mochila: float = 40.0   
var caja_pos_x_caja: float = 320.0    
var caja_pos_y_inicio: float = -70.0   
var caja_separacion_y: float = 30.0   
var caja_separacion_y_caja: float = 29

# Máscara de estados de pantallas del menú
enum ScreenLoaded {NOTHING, JUST_MENU, OBJECTO, ESTADISTICAS, TELEFONO, OBJETO2, INFO, CAJAa, CAJAb, SELECCIONAR_HEROE}
var screen_loaded = ScreenLoaded.NOTHING

# Variables de control para las páginas de estadísticas y selección de héroes
var personaje_seleccionado: int = 0
var objeto_temporal_indice: int = -1

@onready var boton_stat_izq = $Control/NinePatchRect/Estadisticas/BotonesCambiarPersonajes/BotonStatsIzquierda
@onready var boton_stat_der = $Control/NinePatchRect/Estadisticas/BotonesCambiarPersonajes/BotonStatsDerecha

func _ready():
	add_to_group("menu_sistema")
	process_mode = Node.PROCESS_MODE_ALWAYS # Asegura que el script corra siempre
	menu.visible = false
	objetos.visible = false
	estadisticas.visible = false
	telefono.visible = false
	info.visible = false
	if interfaz_caja: interfaz_caja.visible = false
	
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

	var texto_gigante = $Control/NinePatchRect/objeto/ListaInventario/ListaInventario
	if texto_gigante and texto_gigante.has_method("actualizar_texto_inventario"):
		texto_gigante.actualizar_texto_inventario()

func abrir_desde_celular():
	menu.visible = true
	if botonCerrar:
		botonCerrar.visible = DisplayServer.is_touchscreen_available()
		
	objetos.visible = false
	estadisticas.visible = false
	telefono.visible = false
	info.visible = false
	if interfaz_caja: interfaz_caja.visible = false
	select_arrow.visible = true
	selected_option = 0
	select_arrow.position = Vector2(select_x, select_y)
	screen_loaded = ScreenLoaded.JUST_MENU
	
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		jugador.puede_moverse = false
		var anim_actual = jugador.animaciones.animation if "animaciones" in jugador else ""
		var direccion = "down"
		if "right" in anim_actual: direccion = "right"
		elif "left" in anim_actual: direccion = "left"
		elif "top" in anim_actual: direccion = "top"
		if "animaciones" in jugador: jugador.animaciones.play("idle_" + direccion)
		
	var mini_stats = $Control/mini_stats/VBoxContainer/MiniStatsLabel
	if mini_stats and mini_stats.has_method("actualizar_mini_stats"):
		mini_stats.actualizar_mini_stats()

func regresar_un_paso_atras():
	match screen_loaded:
		ScreenLoaded.JUST_MENU:
			cerrar_todo_el_menu_de_golpe()
		ScreenLoaded.OBJECTO, ScreenLoaded.ESTADISTICAS, ScreenLoaded.TELEFONO:
			objetos.visible = false
			estadisticas.visible = false
			telefono.visible = false
			info.visible = false
			if interfaz_caja: interfaz_caja.visible = false
			select_arrow.visible = true
			select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			screen_loaded = ScreenLoaded.JUST_MENU
		ScreenLoaded.OBJETO2:
			screen_loaded = ScreenLoaded.OBJECTO
			select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
		ScreenLoaded.INFO:
			cerrar_info_y_restaurar_pantalla()
		ScreenLoaded.CAJAa, ScreenLoaded.CAJAb:
			if interfaz_caja: interfaz_caja.visible = false
			telefono.visible = true
			selected_option_telefono = 0 if screen_loaded == ScreenLoaded.CAJAa else 1
			selected_option2 = selected_option_telefono
			selected_option3 = 0
			select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
			screen_loaded = ScreenLoaded.TELEFONO

func _input(event):
	match screen_loaded:
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu"):
				if sonido_squeak: sonido_squeak.play()
				abrir_desde_celular()
				get_viewport().set_input_as_handled()

		ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_squeak: sonido_squeak.play()
				regresar_un_paso_atras()
				get_viewport().set_input_as_handled()
			
			elif event.is_action_pressed("ui_menu_down"):
				if sonido_squeak: sonido_squeak.play()
				selected_option = (selected_option + 1) % 3
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			elif event.is_action_pressed("ui_menu_up"):
				if sonido_squeak: sonido_squeak.play()
				selected_option = (selected_option - 1 + 3) % 3
				select_arrow.position = Vector2(select_x, select_y + selected_option * px_d)
				
			elif event.is_action_pressed("acción"):
				ejecutar_accion_menu_principal()

		ScreenLoaded.OBJECTO:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_cambio: sonido_cambio.play()
				regresar_un_paso_atras()
				get_viewport().set_input_as_handled()
			
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
					selected_option3 = 0
					select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
					screen_loaded = ScreenLoaded.OBJETO2

		ScreenLoaded.OBJETO2:
			if event.is_action_pressed("correr") or event.is_action_pressed("menu"):
				if sonido_cambio: sonido_cambio.play()
				screen_loaded = ScreenLoaded.OBJECTO
				select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
				get_viewport().set_input_as_handled()
				
			elif event.is_action_pressed("ui_menu_right"):
				if sonido_squeak: sonido_squeak.play()
				selected_option3 = (selected_option3 + 1) % 3
				select_arrow.position = Vector2(select_x2 + selected_option3 * 105, 184)
				
			elif event.is_action_pressed("ui_menu_left"):
				if sonido_squeak: sonido_squeak.play()
				selected_option3 = (selected_option3 - 1 + 3) % 3
				select_arrow.position = Vector2(select_x2 + selected_option3 * 105, 184)

			elif event.is_action_pressed("acción"):
				ejecutar_accion_sub_menu_objeto()

		ScreenLoaded.SELECCIONAR_HEROE:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_cambio: sonido_cambio.play()
				estadisticas.visible = false
				objetos.visible = true
				if boton_stat_izq: boton_stat_izq.visible = false
				if boton_stat_der: boton_stat_der.visible = false
				screen_loaded = ScreenLoaded.OBJETO2
				select_arrow.position = Vector2(select_x2 + (selected_option3 % 3) * 105, 184)
				get_viewport().set_input_as_handled()
			elif event.is_action_pressed("ui_menu_right"):
				cambiar_personaje_stats(1)
			elif event.is_action_pressed("ui_menu_left"):
				cambiar_personaje_stats(-1)
			elif event.is_action_pressed("acción"):
				efectuar_curacion_tactil(personaje_seleccionado)

		ScreenLoaded.ESTADISTICAS:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_cambio: sonido_cambio.play()
				regresar_un_paso_atras()
				get_viewport().set_input_as_handled()
			elif event.is_action_pressed("ui_menu_right"):
				cambiar_personaje_stats(1)
			elif event.is_action_pressed("ui_menu_left"):
				cambiar_personaje_stats(-1)

		ScreenLoaded.TELEFONO:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_cambio: sonido_cambio.play()
				regresar_un_paso_atras()
				get_viewport().set_input_as_handled()
			
			elif event.is_action_pressed("ui_menu_down") and selected_option_telefono < 1:
				if sonido_squeak: sonido_squeak.play()
				selected_option_telefono += 1
				select_arrow.position = Vector2(select_x2, select_y2 + (selected_option_telefono * 30))
			elif event.is_action_pressed("ui_menu_up") and selected_option_telefono > 0:
				if sonido_squeak: sonido_squeak.play()
				selected_option_telefono -= 1
				select_arrow.position = Vector2(select_x2, select_y2 + (selected_option_telefono * 30))
				
			elif event.is_action_pressed("acción"):
				if sonido_cambio: sonido_cambio.play()
				if selected_option_telefono == 0:
					abrir_interfaz_caja(ScreenLoaded.CAJAa)
				else:
					abrir_interfaz_caja(ScreenLoaded.CAJAb)

		ScreenLoaded.INFO:
			if event.is_action_pressed("correr") or event.is_action_pressed("acción"):
				if texto_escribiendo:
					texto_escribiendo = false
				else:
					if sonido_cambio: sonido_cambio.play()
					cerrar_info_y_restaurar_pantalla()
				get_viewport().set_input_as_handled()

		ScreenLoaded.CAJAa, ScreenLoaded.CAJAb:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				if sonido_cambio: sonido_cambio.play()
				regresar_un_paso_atras()
				get_viewport().set_input_as_handled()
				
			elif event.is_action_pressed("ui_menu_down"):
				var limite_maximo = 7 if selected_option3 == 0 else (diccionario_global.MAX_ESPACIO_CAJA - 1)
				if selected_option2 < limite_maximo:
					if sonido_squeak: sonido_squeak.play()
					selected_option2 += 1
					actualizar_visualizacion_caja()
					
			elif event.is_action_pressed("ui_menu_up"):
				if selected_option2 > 0:
					if sonido_squeak: sonido_squeak.play()
					selected_option2 -= 1
					actualizar_visualizacion_caja()
					
			elif event.is_action_pressed("ui_menu_right") and selected_option3 == 0:
				if sonido_squeak: sonido_squeak.play()
				selected_option3 = 1
				selected_option2 = min(selected_option2, caja_actual_referencia.size() - 1)
				if selected_option2 < 0: selected_option2 = 0
				actualizar_visualizacion_caja()
				
			elif event.is_action_pressed("ui_menu_left") and selected_option3 == 1:
				if sonido_squeak: sonido_squeak.play()
				selected_option3 = 0
				if selected_option2 > 7: selected_option2 = 7
				actualizar_visualizacion_caja()
				
			elif event.is_action_pressed("acción"):
				if selected_option3 == 0:
					guardar_objeto_en_caja(selected_option2)
				else:
					retirar_objeto_de_caja(selected_option2)

func ejecutar_accion_menu_principal():
	if sonido_cambio: sonido_cambio.play()
	match selected_option:
		0:
			objetos.visible = true
			estadisticas.visible = false
			telefono.visible = false
			selected_option2 = 0
			select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
			screen_loaded = ScreenLoaded.OBJECTO
			actualizar_visualizacion_inventario()
		1:
			personaje_seleccionado = 0
			objetos.visible = false
			estadisticas.visible = true
			telefono.visible = false
			screen_loaded = ScreenLoaded.ESTADISTICAS
			select_arrow.visible = true
			select_arrow.position = Vector2(select_x, select_y + (selected_option * px_d))
			
			var es_movil = DisplayServer.is_touchscreen_available()
			if boton_stat_izq: boton_stat_izq.visible = es_movil
			if boton_stat_der: boton_stat_der.visible = es_movil
			
			var label_stats = $Control/NinePatchRect/Estadisticas/VBoxContainer/stats
			if label_stats and label_stats.has_method("actualizar_estadisticas"):
				label_stats.actualizar_estadisticas(personaje_seleccionado)
		2:
			objetos.visible = false
			estadisticas.visible = false
			telefono.visible = true
			selected_option_telefono = 0
			selected_option2 = 0
			select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))
			screen_loaded = ScreenLoaded.TELEFONO

func ejecutar_accion_sub_menu_objeto():
	match selected_option3:
		0: # USAR OBJETO
			objeto_temporal_indice = selected_option2
			var id_item = diccionario_global.inventario[objeto_temporal_indice]
			var datos_item = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item, {})
			var tipo_objeto = datos_item.get("tipo", "")
			
			if tipo_objeto == "objeto curativo" or tipo_objeto == "objetivo curativo":
				if sonido_cambio: sonido_cambio.play()
				screen_loaded = ScreenLoaded.SELECCIONAR_HEROE
				personaje_seleccionado = 0
				objetos.visible = false
				estadisticas.visible = true
				select_arrow.visible = true
				select_arrow.position = Vector2(select_x_stats, select_y_stats[0])
				
				var es_movil = DisplayServer.is_touchscreen_available()
				if boton_stat_izq: boton_stat_izq.visible = es_movil
				if boton_stat_der: boton_stat_der.visible = es_movil
				
				var label_stats = $Control/NinePatchRect/Estadisticas/VBoxContainer/stats
				if label_stats and label_stats.has_method("actualizar_estadisticas"):
					label_stats.actualizar_estadisticas(personaje_seleccionado)
			else:
				objeto_temporal_indice = -1
				aplicar_equipamiento_directo(id_item)
		1: # INFO OBJETO
			var id_objeto = diccionario_global.inventario[selected_option2]
			var info_texto = diccionario_global.obtener_info_objeto(id_objeto)
			mostrar_texto_animado(info_texto)
		2: # TIRAR OBJETO
			var id_objeto = diccionario_global.inventario[selected_option2]
			var nombre_objeto = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_objeto, {}).get("nombre", "Objeto")
			diccionario_global.eliminar_objeto_por_indice(selected_option2)
			mostrar_texto_animado("* Tiraste " + nombre_objeto + ".")
			actualizar_visualizacion_inventario()

func aplicar_equipamiento_directo(id_item_nuevo: String):
	var datos_item = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item_nuevo, {})
	var tipo_objeto = datos_item.get("tipo", "")
	var nombre_objeto = datos_item.get("nombre", "Desconocido")
	var mensaje = ""
	
	if sonido_cambio:
		sonido_cambio.stream = load("res://audio/Interfaz/snd_item.wav")
		sonido_cambio.play()
	
	if tipo_objeto == "Arma":
		var id_arma_vieja = Global.arma_equipada
		Global.arma_equipada = id_item_nuevo
		mensaje = "* Te equipaste " + nombre_objeto + "."
		diccionario_global.eliminar_objeto_por_indice(selected_option2)
		if id_arma_vieja != "" and id_arma_vieja != "Ninguna":
			diccionario_global.añadir_objeto(id_arma_vieja)
	elif tipo_objeto == "Armadura":
		var id_armadura_vieja = Global.armadura_equipada
		Global.armadura_equipada = id_item_nuevo
		mensaje = "* Te equipaste " + nombre_objeto + "."
		diccionario_global.eliminar_objeto_por_indice(selected_option2)
		if id_armadura_vieja != "" and id_armadura_vieja != "Ninguna":
			diccionario_global.añadir_objeto(id_armadura_vieja)
			
	if Global.has_method("actualizar_equipamiento"): Global.actualizar_equipamiento()
	if sonido_cambio: sonido_cambio.stream = load("res://audio/Interfaz/undertale-select-sound.wav")
	
	mostrar_texto_animado(mensaje)
	actualizar_visualizacion_inventario()

func efectuar_curacion_tactil(heroe_id: int):
	if objeto_temporal_indice == -1: return
	var id_item = diccionario_global.inventario[objeto_temporal_indice]
	var datos_item = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item, {})
	var puntos_curacion = datos_item.get("hp", 0)
	var p_nombre = ""
	var mensaje = ""
	
	if sonido_curacion: sonido_curacion.play()
	
	match heroe_id:
		0:
			p_nombre = Global.nombre_p0 if "nombre_p0" in Global else Global.nombre
			var v_actual = Global.vida
			var v_max = Global.vidaMax
			if v_actual >= v_max: mensaje = "* El HP de " + p_nombre + " ya está al máximo."
			else:
				Global.vida = min(v_actual + puntos_curacion, v_max)
				mensaje = "* " + p_nombre + " recuperó " + str(puntos_curacion) + " HP."
				diccionario_global.eliminar_objeto_por_indice(objeto_temporal_indice)
		1:
			p_nombre = Global.nombre_p1 if "nombre_p1" in Global else "Susie"
			var v_actual = Global.vida_p1 if "vida_p1" in Global else 30
			var v_max = Global.vida_max_p1 if "vida_max_p1" in Global else 30
			if v_actual >= v_max: mensaje = "* El HP de " + p_nombre + " ya está al máximo."
			else:
				if "vida_p1" in Global: Global.vida_p1 = min(v_actual + puntos_curacion, v_max)
				mensaje = "* " + p_nombre + " recuperó " + str(puntos_curacion) + " HP."
				diccionario_global.eliminar_objeto_por_indice(objeto_temporal_indice)
		2:
			p_nombre = Global.nombre_p2 if "nombre_p2" in Global else "Ralsei"
			var v_actual = Global.vida_p2 if "vida_p2" in Global else 15
			var v_max = Global.vida_max_p2 if "vida_max_p2" in Global else 15
			if v_actual >= v_max: mensaje = "* El HP de " + p_nombre + " ya está al máximo."
			else:
				if "vida_p2" in Global: Global.vida_p2 = min(v_actual + puntos_curacion, v_max)
				mensaje = "* " + p_nombre + " recuperó " + str(puntos_curacion) + " HP."
				diccionario_global.eliminar_objeto_por_indice(objeto_temporal_indice)

	objeto_temporal_indice = -1
	estadisticas.visible = false
	if boton_stat_izq: boton_stat_izq.visible = false
	if boton_stat_der: boton_stat_der.visible = false
	mostrar_texto_animado(mensaje)
	actualizar_visualizacion_inventario()

func cerrar_todo_el_menu_de_golpe():
	menu.visible = false
	objetos.visible = false
	estadisticas.visible = false
	telefono.visible = false
	info.visible = false
	if interfaz_caja: interfaz_caja.visible = false
	select_arrow.visible = false
	if botonCerrar: botonCerrar.visible = false
	
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		jugador.puede_moverse = true
		
	selected_option = 0
	selected_option2 = 0
	selected_option3 = 0
	selected_option_telefono = 0
	screen_loaded = ScreenLoaded.NOTHING

func cerrar_info_y_restaurar_pantalla():
	info.visible = false
	menu.visible = true
	select_arrow.visible = true
	if objeto_temporal_indice != -1:
		screen_loaded = ScreenLoaded.SELECCIONAR_HEROE
		select_arrow.position = Vector2(select_x_stats, select_y_stats[personaje_seleccionado])
	else:
		screen_loaded = ScreenLoaded.OBJECTO
		select_arrow.position = Vector2(select_x2, select_y2 + (selected_option2 * 30))

func abrir_interfaz_caja(tipo_caja):
	screen_loaded = tipo_caja
	selected_option2 = 0 
	selected_option3 = 0 
	telefono.visible = false
	if interfaz_caja: interfaz_caja.visible = true
	
	if tipo_caja == ScreenLoaded.CAJAa:
		caja_actual_referencia = diccionario_global.caja_a
		if titulo_caja_label: titulo_caja_label.text = " Caja A "
	else:
		caja_actual_referencia = diccionario_global.caja_b
		if titulo_caja_label: titulo_caja_label.text = " Caja B "
		
	if texto_indicador:
		if DisplayServer.is_touchscreen_available():
			texto_indicador.text = "[color=#ffff00][Tocar][/color] Guardar o Retirar objeto"
		else:
			texto_indicador.text = "[color=#ffff00][Z/ENTER][/color] Transferir      [color=#ffff00][X/SHIFT][/color] Salir"
	actualizar_visualizacion_caja()

func actualizar_visualizacion_caja():
	if not lista_caja_inventario or not lista_caja_dimensional: return
	select_arrow.visible = true
	
	var texto_mochila = ""
	for i in range(8):
		if i < diccionario_global.inventario.size():
			var id_item = diccionario_global.inventario[i]
			texto_mochila += diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item, {}).get("nombre", "Objeto") + "\n"
		else:
			texto_mochila += "[color=red]------------[/color]\n"
	lista_caja_inventario.text = texto_mochila

	var texto_caja = ""
	for j in range(diccionario_global.MAX_ESPACIO_CAJA):
		if j < caja_actual_referencia.size():
			var id_item = caja_actual_referencia[j]
			texto_caja += diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_item, {}).get("nombre", "Objeto") + "\n"
		else:
			texto_caja += "[color=red]------------[/color]\n"
	lista_caja_dimensional.text = texto_caja

	var destino_x = caja_pos_x_mochila if selected_option3 == 0 else caja_pos_x_caja
	var sep_y = caja_separacion_y if selected_option3 == 0 else caja_separacion_y_caja
	select_arrow.position = Vector2(destino_x, caja_pos_y_inicio + (selected_option2 * sep_y))

func guardar_objeto_en_caja(indice_inventario: int):
	if diccionario_global.inventario.size() > indice_inventario:
		if caja_actual_referencia.size() < diccionario_global.MAX_ESPACIO_CAJA:
			var id_item = diccionario_global.inventario[indice_inventario]
			caja_actual_referencia.append(id_item)
			diccionario_global.eliminar_objeto_por_indice(indice_inventario)
			actualizar_visualizacion_inventario()
			actualizar_visualizacion_caja()
			if sonido_cambio: sonido_cambio.play()
			
			selected_option2 = min(selected_option2, max(0, diccionario_global.inventario.size() - 1))
			actualizar_visualizacion_caja()

func retirar_objeto_de_caja(indice_caja: int):
	if caja_actual_referencia.size() > indice_caja:
		if diccionario_global.inventario.size() < 8:
			var id_item = caja_actual_referencia[indice_caja]
			diccionario_global.añadir_objeto(id_item)
			caja_actual_referencia.remove_at(indice_caja)
			actualizar_visualizacion_inventario()
			actualizar_visualizacion_caja()
			if sonido_cambio: sonido_cambio.play()
			
			selected_option2 = min(selected_option2, max(0, caja_actual_referencia.size() - 1))
			actualizar_visualizacion_caja()

func cambiar_personaje_stats(direccion: int):
	if sonido_squeak: sonido_squeak.play()
	personaje_seleccionado = (personaje_seleccionado + direccion + 3) % 3
	var label_stats = $Control/NinePatchRect/Estadisticas/VBoxContainer/stats
	if label_stats and label_stats.has_method("actualizar_estadisticas"):
		label_stats.actualizar_estadisticas(personaje_seleccionado)
	if screen_loaded == ScreenLoaded.SELECCIONAR_HEROE:
		select_arrow.visible = true
		select_arrow.position = Vector2(select_x_stats, select_y_stats[personaje_seleccionado])

#func reproducir_sonido_seleccion():
#	if sonido_cambio and sonido_cambio.stream: sonido_cambio.play()

# --- SEÑALES TÁCTILES ---
func _on_boton_cerrar_pressed():
	regresar_un_paso_atras()


# --- SEÑALES TÁCTILES DEL MENÚ PRINCIPAL ---
func _on_boton_objeto_pressed():
	if screen_loaded == ScreenLoaded.JUST_MENU:
		selected_option = 0
		ejecutar_accion_menu_principal()

func _on_boton_estadisticas_pressed():
	if screen_loaded == ScreenLoaded.JUST_MENU:
		selected_option = 1
		ejecutar_accion_menu_principal()

func _on_boton_telefono_pressed():
	if screen_loaded == ScreenLoaded.JUST_MENU:
		selected_option = 2
		ejecutar_accion_menu_principal()


# --- SEÑALES TÁCTILES DEL INVENTARIO ---
func _on_boton_item_1_pressed(): procesar_toque_item(0)
func _on_boton_item_2_pressed(): procesar_toque_item(1)
func _on_boton_item_3_pressed(): procesar_toque_item(2)
func _on_boton_item_4_pressed(): procesar_toque_item(3)
func _on_boton_item_5_pressed(): procesar_toque_item(4)
func _on_boton_item_6_pressed(): procesar_toque_item(5)
func _on_boton_item_7_pressed(): procesar_toque_item(6)
func _on_boton_item_8_pressed(): procesar_toque_item(7)

func procesar_toque_item(indice: int):
	if screen_loaded == ScreenLoaded.OBJECTO:
		if indice < diccionario_global.inventario.size():
			var id_objeto = diccionario_global.inventario[indice]
			if id_objeto != "":
				if sonido_cambio: sonido_cambio.play()
				selected_option2 = indice
				screen_loaded = ScreenLoaded.OBJETO2
				selected_option3 = 0
				select_arrow.position = Vector2(select_x2 + selected_option3 * 105, 184)

func _on_boton_usar_pressed():
	if screen_loaded == ScreenLoaded.OBJETO2:
		selected_option3 = 0
		ejecutar_accion_sub_menu_objeto()

func _on_boton_info_pressed():
	if screen_loaded == ScreenLoaded.OBJETO2:
		selected_option3 = 1
		ejecutar_accion_sub_menu_objeto()

func _on_boton_tirar_pressed():
	if screen_loaded == ScreenLoaded.OBJETO2:
		selected_option3 = 2
		ejecutar_accion_sub_menu_objeto()


# --- BOTONES DE LA CAJA (IZQUIERDA - MOCHILA) ---
func _on_boton_inventario_pressed() -> void: ejecutar_accion_tactil_caja(0, 0)
func _on_boton_inventario_2_pressed() -> void: ejecutar_accion_tactil_caja(1, 0)
func _on_boton_inventario_3_pressed() -> void: ejecutar_accion_tactil_caja(2, 0)
func _on_boton_inventario_4_pressed() -> void: ejecutar_accion_tactil_caja(3, 0)
func _on_boton_inventario_5_pressed() -> void: ejecutar_accion_tactil_caja(4, 0)
func _on_boton_inventario_6_pressed() -> void: ejecutar_accion_tactil_caja(5, 0)
func _on_boton_inventario_7_pressed() -> void: ejecutar_accion_tactil_caja(6, 0)
func _on_boton_inventario_8_pressed() -> void: ejecutar_accion_tactil_caja(7, 0)

# --- BOTONES DE LA CAJA (DERECHA - CAJA DIMENSIONAL) ---
func _on_boton_caja_item_1_pressed() -> void: ejecutar_accion_tactil_caja(0, 1)
func _on_boton_caja_item_2_pressed() -> void: ejecutar_accion_tactil_caja(1, 1)
func _on_boton_caja_item_3_pressed() -> void: ejecutar_accion_tactil_caja(2, 1)
func _on_boton_caja_item_4_pressed() -> void: ejecutar_accion_tactil_caja(3, 1)
func _on_boton_caja_item_5_pressed() -> void: ejecutar_accion_tactil_caja(4, 1)
func _on_boton_caja_item_6_pressed() -> void: ejecutar_accion_tactil_caja(5, 1)
func _on_boton_caja_item_7_pressed() -> void: ejecutar_accion_tactil_caja(6, 1)
func _on_boton_caja_item_8_pressed() -> void: ejecutar_accion_tactil_caja(7, 1)
func _on_boton_caja_item_9_pressed() -> void: ejecutar_accion_tactil_caja(8, 1)
func _on_boton_caja_item_10_pressed() -> void: ejecutar_accion_tactil_caja(9, 1)

func ejecutar_accion_tactil_caja(fila: int, columna: int):
	if screen_loaded == ScreenLoaded.CAJAa or screen_loaded == ScreenLoaded.CAJAb:
		if sonido_squeak: sonido_squeak.play()
		
		selected_option2 = fila
		selected_option3 = columna
		
		# CORRECCIÓN: Quitamos la sobreescritura forzada de 'screen_loaded' 
		# para que no interfiera con qué caja (A o B) está leyendo la transferencia
		actualizar_visualizacion_caja()
		if selected_option3 == 0:
			guardar_objeto_en_caja(selected_option2)
		else:
			retirar_objeto_de_caja(selected_option2)


# --- REPRODUCCIÓN AUDIO ---
func reproducir_sonido_seleccion():
	if sonido_cambio:
		if sonido_cambio.stream: sonido_cambio.play()
		else:
			sonido_cambio.stream = load("res://audio/Interfaz/undertale-select-sound.wav")
			sonido_cambio.play()


# --- TEXTO INFO ANIMADO ---
func mostrar_texto_animado(texto_completo: String):
	var label_info = info.get_node_or_null("Label")
	if not label_info: return
		
	label_info.text = "" 
	menu.visible = false
	info.visible = true
	select_arrow.visible = false
	screen_loaded = ScreenLoaded.INFO
	
	texto_escribiendo = true
	for i in range(texto_completo.length()):
		if not texto_escribiendo: break
		label_info.text += texto_completo[i]
		if texto_completo[i] != " " and sonido_texto: sonido_texto.play()
		await get_tree().create_timer(0.04).timeout

	texto_escribiendo = false
	if sonido_texto: sonido_texto.stop()


# --- SEÑALES TÁCTILES PARA CAMBIAR DE PERSONAJE EN MÓVIL ---
func _on_boton_stats_izquierda_pressed() -> void:
	if screen_loaded == ScreenLoaded.ESTADISTICAS or screen_loaded == ScreenLoaded.SELECCIONAR_HEROE:
		cambiar_personaje_stats(-1)

func _on_boton_stats_derecha_pressed() -> void:
	# CORRECCIÓN: Aseguramos una evaluación limpia de estados para móviles
	if screen_loaded == ScreenLoaded.ESTADISTICAS or screen_loaded == ScreenLoaded.SELECCIONAR_HEROE:
		cambiar_personaje_stats(1)

# --- SEÑAL TÁCTIL PARA CONFIRMAR AL HÉROE SELECCIONADO EN MÓVIL ---
func _on_boton_confirmar_heroe_tactil_pressed() -> void:
	if screen_loaded == ScreenLoaded.SELECCIONAR_HEROE:
		efectuar_curacion_tactil(personaje_seleccionado)


# --- SEÑALES CONECTADAS DESDE EL EDITOR DE NODOS ---
func _on_boton_caja_a_pressed() -> void:
	if screen_loaded == ScreenLoaded.TELEFONO:
		if sonido_cambio: sonido_cambio.play()
		abrir_interfaz_caja(ScreenLoaded.CAJAa)

func _on_boton_caja_b_pressed() -> void:
	if screen_loaded == ScreenLoaded.TELEFONO:
		if sonido_cambio: sonido_cambio.play()
		abrir_interfaz_caja(ScreenLoaded.CAJAb)

		
