extends CanvasLayer

@onready var controles = $Control
@onready var controles2 = $Control2
var proxima_posicion_jugador: Vector2 = Vector2.ZERO

func _ready():
	# Detectamos si el jugador está en Android, iOS, Web Móvil o si hay pantalla táctil real
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios") or DisplayServer.is_touchscreen_available():
		# Si es celular, forzamos el modo EXPAND para liberar los controles táctile
		controles.visible = true
		controles2.visible = true
	else:
		# Si es PC (Windows, Mac, Linux, Web de escritorio), forzamos KEEP para mantener el 4:3
		get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
		controles.visible = false
		controles2.visible = false

# Función antigua/duplicada por seguridad la dejamos con un aviso
func _on_boton_y_pressed():
	pass

# ESTA ES LA SEÑAL REAL CONECTADA EN TU TSCN
func _on_y_pressed() -> void:
		print("Botón Y presionado: Abriendo menú...")
			
# Buscamos al menú usando su grupo global y le ordenamos abrirse
		var menu_nodo = get_tree().get_first_node_in_group("menu_sistema")
		if menu_nodo:
	# Le damos un respiro mínimo de un frame para que el botón alcance a 
		# dibujar la textura pressed antes de desaparecer por completo
			await get_tree().process_frame
			menu_nodo.abrir_desde_celular()
			
