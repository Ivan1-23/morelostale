extends TouchScreenButton
# Código DENTRO del script de tu botón Y (en la escena de controles táctiles)
func _on_pressed() -> void:
	# Creamos un evento artificial idéntico a presionar la tecla de menú
	var evento = InputEventAction.new()
	evento.action = "menu"
	evento.pressed = true
	
	# Lo enviamos directamente al motor del juego
	Input.parse_input_event(evento)
