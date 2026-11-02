extends Label

func _ready() -> void:
	actualizar_save()

func actualizar_save():
	# 1. Obtenemos los datos directamente del diccionario de GestorGuardado
	var segundos_totales = int(GestorGuardado.datos_partida.get("tiempo_jugado_segundos", 0))
	var minutos = segundos_totales / 60
	var segundos = segundos_totales % 60
	var tiempo_formateado = "%02d:%02d" % [minutos, segundos]
	
	var zona = GestorGuardado.datos_partida.get("zona_actual", "Zona")
	var subzona = GestorGuardado.datos_partida.get("subzona_actual", "Subzona")
	var nv = GestorGuardado.datos_partida.get("NV", 1)
	
	# 2. Construimos el texto dinámicamente con los valores reales
	text = "SEBO" + "  " + "NV  " + str(nv) + "                    " + tiempo_formateado + "\n" + zona + "  -  " + subzona + "\n" + "\n "+ "  Guardar     " + "      Volver  "
