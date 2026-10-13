extends Label

# Se ejecuta solo una vez al abrir la pantalla de guardado
func _ready() -> void:
	actualizar_save()

func actualizar_save():
	# 1. Obtenemos y calculamos los minutos y segundos estáticos guardados en el Autoload
	var segundos_totales = int(Global.tiempo_jugado_segundos) if "tiempo_jugado_segundos" in Global else 0
	@warning_ignore("integer_division")
	var minutos = segundos_totales / 60
	var segundos = segundos_totales % 60
	var tiempo_formateado = "%02d:%02d" % [minutos, segundos]
	
	# 2. Obtenemos la zona y subzona fijadas por el último punto de guardado tocado
	var zona = Global.zona_actual if "zona_actual" in Global else "Zona"
	var subzona = Global.subzona_actual if "subzona_actual" in Global else "Subzona"
	
	# 3. Construimos el texto con los datos fijos
	text = "SEBO" + "  " + "NV  " + str(Global.NV) + "                    " + tiempo_formateado + "\n" + "[" + zona + "]  -  [" + subzona + "]" + "\n" + "\n "+ "  Guardar     " + "      Volver  "
