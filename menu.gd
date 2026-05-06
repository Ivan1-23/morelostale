extends CanvasLayer
#variables
@onready var select_arrow = $Control/NinePatchRect/TextureRect
@onready var menu = $Control
@onready var objetos = $Control/NinePatchRect/objeto
@onready var estadisticas = $Control/NinePatchRect/Estadisticas
@onready var telefono = $Control/NinePatchRect/Telefono
@onready var info = $Control2/info
@onready var button1 = $Control/NinePatchRect/OBJT
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
	#opciones del menu
func _unhandled_input(event):
	match screen_loaded:
#---------------------------------
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu"):
				menu.visible = true
				screen_loaded = ScreenLoaded.JUST_MENU
				get_parent().puede_moverse = false # Bloquea al jugador
#----------------------------------
		ScreenLoaded.JUST_MENU:
			
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
				get_parent().puede_moverse = true # Libera al jugador
			elif event.is_action_pressed("ui_down"):
				selected_option +=1
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
			elif event.is_action_pressed("ui_up"):
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
			elif event.is_action_pressed("ui_down"):
				selected_option2 += 1
				select_arrow.position = Vector2(176,-70 + (selected_option2 % 8 * 30))
			elif event.is_action_pressed("ui_up"):
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
				get_parent().puede_moverse = true # Libera al jugador
			elif event.is_action_pressed("acción") and selected_option3 == 1:
				objetos.visible = false
				select_arrow.visible = false
				select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
				screen_loaded = ScreenLoaded.INFO
			elif event.is_action_pressed("ui_right"):
				selected_option3 += 1
				select_arrow.position = Vector2(176 + (selected_option3 % 3) * 105,184)
			elif event.is_action_pressed("ui_left"):
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
				screen_loaded = ScreenLoaded.NOTHING
				get_parent().puede_moverse = true # Libera al jugador
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
			elif event.is_action_pressed("ui_down"):
				selected_option2 += 1
				select_arrow.position = Vector2(176,-70 + (selected_option2 % 2 * 30))
			elif event.is_action_pressed("ui_up"):
				if selected_option2 == 0:
					select_arrow.position = Vector2(176,-70 + (selected_option2 % 2 * 30))
				else:
					selected_option2 -= 1
					select_arrow.position = Vector2(176,-70 + (selected_option2 % 2 * 30))
