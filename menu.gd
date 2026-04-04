extends CanvasLayer

@onready var select_arrow = $Control/NinePatchRect/TextureRect
@onready var menu = $Control
@onready var objetos = $Control/NinePatchRect/objeto
@onready var estadisticas = $Control/NinePatchRect/Estadisticas
@onready var telefono = $Control/NinePatchRect/Telefono
var select_x = 18
var select_y = 28
var px_d = 48
enum ScreenLoaded {NOTHING, JUST_MENU, OBJECTO, ESTADISTICAS, TELEFONO}
var screen_loaded = ScreenLoaded.NOTHING
var selected_option: int = 0

func _ready():
	menu.visible = false
	select_arrow.position = Vector2(select_x, select_y + (selected_option % 3) * px_d)
	
func _unhandled_input(event):
	match screen_loaded:
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu"):
				menu.visible = true
				screen_loaded = ScreenLoaded.JUST_MENU
		ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("menu"):
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
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
		ScreenLoaded.OBJECTO:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				objetos.visible = false
				screen_loaded = ScreenLoaded.JUST_MENU
		ScreenLoaded.ESTADISTICAS:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				estadisticas.visible = false
				screen_loaded = ScreenLoaded.JUST_MENU
		ScreenLoaded.TELEFONO:
			if event.is_action_pressed("menu") or event.is_action_pressed("correr"):
				telefono.visible = false
				screen_loaded = ScreenLoaded.JUST_MENU
