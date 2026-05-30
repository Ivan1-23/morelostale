extends CanvasLayer
#variables
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
@onready var botonTirar= $Control/NinePatchRect/objeto/BotonTirar
@onready var controls = $touch_button
var select_x = 28
var select_y = 35
var px_d = 33
enum ScreenLoaded {NOTHING, JUST_MENU, OBJECTO, ESTADISTICAS, TELEFONO,OBJETO2,INFO,CAJAa,CAJAb}
var screen_loaded = ScreenLoaded.NOTHING
var selected_option: int = 0
var selected_option2: int = 0
var selected_option3: int = 0

func _ready():
	menu.visible = false
	select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
	if not DisplayServer.is_touchscreen_available():
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
		botonTelefono.visible = false
	#opciones del menu
func _unhandled_input(event):
	match screen_loaded:
#---------------------------------
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu"):
				menu.visible = true
				screen_loaded = ScreenLoaded.JUST_MENU
				controls.visible = false
				get_parent().puede_moverse = false # Bloquea al jugador
#----------------------------------
		ScreenLoaded.JUST_MENU:
			
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
				controls.visible = true
				get_parent().puede_moverse = true # Libera al jugador
			elif event.is_action_pressed("ui_menu_down"):
				selected_option +=1
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			elif event.is_action_pressed("ui_menu_up"):
				if selected_option == 0:
					select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
				else:
					selected_option -= 1
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			elif event.is_action_pressed("acción") and selected_option == 0:
				objetos.visible = true
				screen_loaded = ScreenLoaded.OBJECTO
			elif event.is_action_pressed("acción") and selected_option == 1:
				estadisticas.visible = true
				screen_loaded = ScreenLoaded.ESTADISTICAS
			elif event.is_action_pressed("acción") and selected_option == 2:
				telefono.visible = true
				screen_loaded = ScreenLoaded.TELEFONO
#----------------------------------
		ScreenLoaded.OBJECTO:
			select_arrow.position = Vector2(176,-70 + (selected_option2 % 8 * 30))
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				objetos.visible = false
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
				screen_loaded = ScreenLoaded.JUST_MENU
			elif event.is_action_pressed("ui_menu_down"):
				selected_option2 += 1
				select_arrow.position = Vector2(176,-70 + (selected_option2 % 8 * 30))
			elif event.is_action_pressed("ui_menu_up"):
				if selected_option2 == 0:
					select_arrow.position = Vector2(176,-70 + (selected_option2 % 8 * 30))
				else:
					selected_option2 -= 1
					select_arrow.position = Vector2(176,-70 + (selected_option2 % 8 * 30))
			elif event.is_action_pressed("acción"):
				select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105,184)
				screen_loaded = ScreenLoaded.OBJETO2
#----------------------------------
		ScreenLoaded.OBJETO2:
			if  event.is_action_pressed("correr") or event.is_action_pressed("menu"):
				menu.visible = false
				objetos.visible = false
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
				screen_loaded = ScreenLoaded.NOTHING
				controls.visible = true
				get_parent().puede_moverse = true # Libera al jugador
			elif event.is_action_pressed("acción") and selected_option3 == 0:
				menu.visible = false
				objetos.visible = false
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
				screen_loaded = ScreenLoaded.NOTHING
				controls.visible = true
				get_parent().puede_moverse = true # Libera al jugador
			elif event.is_action_pressed("acción") and selected_option3 == 1:
				objetos.visible = false
				select_arrow.visible = false
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
				screen_loaded = ScreenLoaded.INFO
			elif event.is_action_pressed("acción") and selected_option3 == 2:
				menu.visible = false
				objetos.visible = false
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
				screen_loaded = ScreenLoaded.NOTHING
				controls.visible = true
				get_parent().puede_moverse = true # Libera al jugador
			elif event.is_action_pressed("ui_menu_right"):
				selected_option3 += 1
				select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105,184)
			elif event.is_action_pressed("ui_menu_left"):
				if selected_option3 == 0:
					select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105,184)
				else:
					selected_option3 -=1
					select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105,184)
#----------------------------------
		ScreenLoaded.INFO:
			info.visible = true
			if event.is_action_pressed("acción"):
				info.visible = false
				select_arrow.visible = true
				menu.visible = false
				controls.visible = true
				get_parent().puede_moverse = true
				screen_loaded = ScreenLoaded.NOTHING # Libera al jugador
#----------------------------------
		ScreenLoaded.ESTADISTICAS:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				estadisticas.visible = false
				screen_loaded = ScreenLoaded.JUST_MENU
#----------------------------------
		ScreenLoaded.TELEFONO:
			select_arrow.position = Vector2(176,-70 + (selected_option2 % 2 * 30))
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				telefono.visible = false
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
				screen_loaded = ScreenLoaded.JUST_MENU
			elif event.is_action_pressed("ui_menu_down"):
				selected_option2 += 1
				select_arrow.position = Vector2(176,-70 + (selected_option2 % 2 * 30))
			elif event.is_action_pressed("ui_menu_up"):
				if selected_option2 == 0:
					select_arrow.position = Vector2(176,-70 + (selected_option2 % 2 * 30))
				else:
					selected_option2 -= 1
					select_arrow.position = Vector2(176,-70 + (selected_option2 % 2 * 30))
#-----------------------------------
func _on_boton_objeto_pressed():
	if screen_loaded == ScreenLoaded.JUST_MENU:
		selected_option = 0
		select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
		objetos.visible = true
		screen_loaded = ScreenLoaded.OBJECTO

func _on_boton_estadisticas_pressed():
	if screen_loaded == ScreenLoaded.JUST_MENU:
		selected_option = 1
		select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
		estadisticas.visible = true
		screen_loaded = ScreenLoaded.ESTADISTICAS

func _on_boton_telefono_pressed():
	if screen_loaded == ScreenLoaded.JUST_MENU:
		selected_option = 2
		select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
		telefono.visible = true
		screen_loaded = ScreenLoaded.TELEFONO


func _on_boton_item_1_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 0
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		
func _on_boton_item_2_pressed():
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 1
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		
func _on_boton_item_3_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 2
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		
func _on_boton_item_4_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 3
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		
func _on_boton_item_5_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 4
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		
func _on_boton_item_6_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 5
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		
func _on_boton_item_7_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 6
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		
func _on_boton_item_8_pressed() -> void:
	if screen_loaded == ScreenLoaded.OBJECTO:
		selected_option2 = 7
		select_arrow.position = Vector2(176, -70 + (selected_option2 % 8 * 30))
		
func _on_boton_usar_pressed():
	if screen_loaded == ScreenLoaded.OBJETO2:
		selected_option3 = 0
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		menu.visible = false
		objetos.visible = false
		select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
		controls.visible = true
		get_parent().puede_moverse = true
		screen_loaded = ScreenLoaded.NOTHING
		# Aquí iría la lógica de usar el objeto

func _on_boton_info_pressed():
	if screen_loaded == ScreenLoaded.OBJETO2:
		selected_option3 = 1
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		# Lógica para mostrar info (tu ScreenLoaded.INFO)
		objetos.visible = false
		select_arrow.visible = false
		select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
		screen_loaded = ScreenLoaded.INFO

func _on_boton_tirar_pressed():
	selected_option3 = 2
	if screen_loaded == ScreenLoaded.OBJETO2:
		select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105, 184)
		menu.visible = false
		objetos.visible = false
		select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
		controls.visible = true
		get_parent().puede_moverse = true
		screen_loaded = ScreenLoaded.NOTHING
