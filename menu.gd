extends CanvasLayer

@onready var select_arrow = $Control/NinePatchRect/TextureRect
@onready var menu = $Control

enum ScreenLoaded {NOTHING, JUST_MENU, OBJECTO, ESTADISTICAS, TELEFONO}
var screen_loaded = ScreenLoaded.NOTHING
var selected_option: int = 0

func _ready():
	menu.visible = false
	select_arrow.position = Vector2(15,28)
	
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
				select_arrow.position = Vector2(15,28+14)
			elif event.is_action_pressed("ui_up"):
				if selected_option == 0:
					selected_option = 2
				else:
					selected_option -= 1
				select_arrow.position = Vector2(15,28-14)
