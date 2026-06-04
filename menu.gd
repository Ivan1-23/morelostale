extends CanvasLayer

# variables de nodos del menú
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

# NUEVO: Tu botón de la esquina para cerrar
@onready var botonCerrar = $Control/BotonCerrar 

@onready var controls = get_tree().current_scene.find_child("touch_button", true, false) if is_inside_tree() else null

var select_x = 28
var select_y = 35
var px_d = 33

enum ScreenLoaded {NOTHING, JUST_MENU, OBJECTO, ESTADISTICAS, TELEFONO, OBJETO2, INFO, CAJAa, CAJAb}
var screen_loaded = ScreenLoaded.NOTHING

var selected_option: int = 0
var selected_option2: int = 0
var selected_option3: int = 0

func _ready():
	add_to_group("menu_sistema")
	
	# Ocultamos todo al empezar de forma segura
	menu.visible = false
	objetos.visible = false
	estadisticas.visible = false
	telefono.visible = false
	info.visible = false
	
	select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
	
	if menu:
		menu.mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Si no estás en celular, ocultamos los botones táctiles incluidos el de cerrar
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

func abrir_desde_celular():
	if screen_loaded == ScreenLoaded.NOTHING:
		menu.visible = true
		objetos.visible = false
		estadisticas.visible = false
		telefono.visible = false
		info.visible = false
		select_arrow.visible = true
		
		# Mostramos el botón de cerrar en la esquina
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

# Función limpia que apaga absolutamente todo y limpia la pantalla
func regresar_un_paso_atras():
	match screen_loaded:
		ScreenLoaded.JUST_MENU:
			# Si está en el menú principal, el botón cierra todo por completo
			menu.visible = false
			screen_loaded = ScreenLoaded.NOTHING
			
			# SOLUCIÓN: Reestablecemos el corazón a la opción inicial (Índice 0)
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
			# Si está metido en submenús, el botón lo regresa al menú principal
			objetos.visible = false
			estadisticas.visible = false
			telefono.visible = false
			select_arrow.visible = true
			select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			screen_loaded = ScreenLoaded.JUST_MENU
			
		ScreenLoaded.OBJETO2:
			# Si está eligiendo Usar/Info/Tirar, regresa a la lista de objetos
			select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
			screen_loaded = ScreenLoaded.OBJECTO
			
		ScreenLoaded.INFO:
			# Si está leyendo la info, cierra el cuadro y vuelve a Usar/Info/Tirar
			info.visible = false
			select_arrow.visible = true
			objetos.visible = true
			select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
			screen_loaded = ScreenLoaded.OBJETO2


func _input(event):
	# ELIMINADO EL FILTRO DE PANTALLA TÁCTIL GLOBAL QUE DABA BUGS.
	# Ahora el teclado sigue funcionando de forma idéntica y perfecta:
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
			select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				regresar_un_paso_atras()
			elif event.is_action_pressed("ui_menu_down"):
				selected_option2 += 1
				select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
			elif event.is_action_pressed("ui_menu_up"):
				if selected_option2 == 0:
					select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
				else:
					selected_option2 -= 1
					select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
			elif event.is_action_pressed("acción"):
				select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
				screen_loaded = ScreenLoaded.OBJETO2

		ScreenLoaded.OBJETO2:
			if event.is_action_pressed("correr") or event.is_action_pressed("menu"):
				regresar_un_paso_atras()
			elif event.is_action_pressed("acción") and selected_option3 == 0:
				screen_loaded = ScreenLoaded.JUST_MENU
				regresar_un_paso_atras()
			elif event.is_action_pressed("acción") and selected_option3 == 1:
				_on_boton_info_pressed()
			elif event.is_action_pressed("acción") and selected_option3 == 2:
				screen_loaded = ScreenLoaded.JUST_MENU
				regresar_un_paso_atras()
			elif event.is_action_pressed("ui_menu_right"):
				selected_option3 += 1
				select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
			elif event.is_action_pressed("ui_menu_left"):
				if selected_option3 == 0:
					select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
				else:
					selected_option3 -= 1
					select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)

		ScreenLoaded.INFO:
			if event.is_action_pressed("acción"):
				regresar_un_paso_atras()

		ScreenLoaded.ESTADISTICAS, ScreenLoaded.TELEFONO:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				regresar_un_paso_atras()

# --- NUEVA SEÑAL DEL BOTÓN DE LA ESQUINA ---
func _on_boton_cerrar_pressed() -> void:
	# Este botón inteligente sabrá exactamente qué cerrar dependiendo de dónde estés metido
	regresar_un_paso_atras()

# --- BOTONES TÁCTILES PRINCIPALES ---
func _on_boton_objeto_pressed():
	selected_option = 0
	select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
	objetos.visible = true
	estadisticas.visible = false
	telefono.visible = false
	screen_loaded = ScreenLoaded.OBJECTO

func _on_boton_estadisticas_pressed():
	selected_option = 1
	select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
	objetos.visible = false
	estadisticas.visible = true
	telefono.visible = false
	screen_loaded = ScreenLoaded.ESTADISTICAS

func _on_boton_telefono_pressed():
	selected_option = 2
	select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
	objetos.visible = false
	estadisticas.visible = false
	telefono.visible = true
	screen_loaded = ScreenLoaded.TELEFONO

# --- SELECCIÓN DE ITEMS TÁCTILES ---
func _on_boton_item_1_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 0
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_2_pressed():
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 1
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_3_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 2
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_4_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 3
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_5_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 4
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_6_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 5
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_7_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 6
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

func _on_boton_item_8_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 7
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		screen_loaded = ScreenLoaded.OBJETO2

# --- ACCIONES DE LOS ITEMS ---
func _on_boton_usar_pressed():
	screen_loaded = ScreenLoaded.JUST_MENU
	regresar_un_paso_atras()

func _on_boton_info_pressed():
	selected_option3 = 1
	select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
	objetos.visible = false
	estadisticas.visible = false
	telefono.visible = false
	select_arrow.visible = false
	info.visible = true
	screen_loaded = ScreenLoaded.INFO

func _on_boton_tirar_pressed():
	screen_loaded = ScreenLoaded.JUST_MENU
	regresar_un_paso_atras()
