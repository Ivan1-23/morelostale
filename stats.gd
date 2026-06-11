extends RichTextLabel

func _ready() -> void:
	actualizar_estadisticas(0) # Inicia mostrando al personaje 0 por defecto

func actualizar_estadisticas(heroe_id: int = 0) -> void:
	# 1. Aseguramos que antes de pintar, Global tenga los extras bien calculados
	if Global.has_method("actualizar_equipamiento"):
		Global.actualizar_equipamiento()
		
	# 2. Obtenemos los datos dinámicamente según el héroe seleccionado
	var p_nombre: String = ""
	var p_nv: int = 1
	var p_vida: int = 0
	var p_vida_max: int = 0
	
	# Variables locales para capturar el equipamiento y los stats correctos por ID
	var id_arma: String = "Ninguna"
	var id_armadura: String = "Ninguna"
	var p_atq: int = 0
	var p_atq_extra: int = 0
	var p_def: int = 0
	var p_def_extra: int = 0
	
	match heroe_id:
		0:
			p_nombre = Global.nombre_p0 if "nombre_p0" in Global else Global.nombre
			p_nv = Global.NV if "NV" in Global else 1
			p_vida = Global.vida
			p_vida_max = Global.vidaMax
			
			id_arma = Global.arma_equipada if "arma_equipada" in Global else "Ninguna"
			id_armadura = Global.armadura_equipada if "armadura_equipada" in Global else "Ninguna"
			p_atq = Global.ATQ if "ATQ" in Global else 10
			p_atq_extra = Global.ATQ_extra if "ATQ_extra" in Global else 0
			p_def = Global.DEF if "DEF" in Global else 0
			p_def_extra = Global.DEF_extra if "DEF_extra" in Global else 0
		1:
			p_nombre = Global.nombre_p1 if "nombre_p1" in Global else "Smuffy"
			p_nv = Global.nv_p1 if "nv_p1" in Global else 1
			p_vida = Global.vida_p1 if "vida_p1" in Global else 30
			p_vida_max = Global.vida_max_p1 if "vida_max_p1" in Global else 30
			
			# CORRECCIÓN AQUÍ: nombres idénticos a global.gd
			id_arma = Global.arma_p1 if "arma_p1" in Global else "Ninguna"
			id_armadura = Global.armadura_p1 if "armadura_p1" in Global else "Ninguna"
			p_atq = Global.ATQ_p1 if "ATQ_p1" in Global else 14
			p_atq_extra = Global.ATQ_extra_p1 if "ATQ_extra_p1" in Global else 0
			p_def = Global.DEF_p1 if "DEF_p1" in Global else 1
			p_def_extra = Global.DEF_extra_p1 if "DEF_extra_p1" in Global else 0
		2:
			p_nombre = Global.nombre_p2 if "nombre_p2" in Global else "Arisa"
			p_nv = Global.nv_p2 if "nv_p2" in Global else 1
			p_vida = Global.vida_p2 if "vida_p2" in Global else 15
			p_vida_max = Global.vida_max_p2 if "vida_max_p2" in Global else 15
			
			# CORRECCIÓN AQUÍ: nombres idénticos a global.gd
			id_arma = Global.arma_p2 if "arma_p2" in Global else "Ninguna"
			id_armadura = Global.armadura_p2 if "armadura_p2" in Global else "Ninguna"
			p_atq = Global.ATQ_p2 if "ATQ_p2" in Global else 8
			p_atq_extra = Global.ATQ_extra_p2 if "ATQ_extra_p2" in Global else 0
			p_def = Global.DEF_p2 if "DEF_p2" in Global else 2
			p_def_extra = Global.DEF_extra_p2 if "DEF_extra_p2" in Global else 0

	# Filtro de seguridad para evitar textos en blanco
	if id_arma == "" or id_arma == "Lápiz" or id_arma == "Lapiz": id_arma = "Ninguna"
	if id_armadura == "" or id_armadura == "Borrador": id_armadura = "Ninguna"

	var datos_arma = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_arma, {})
	var datos_armadura = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_armadura, {})
	
	var nombre_arma = datos_arma.get("nombre", "Ninguna")
	var nombre_armadura = datos_armadura.get("nombre", "Ninguna")
	
	# 4. Pintamos la pantalla con las variables locales dinámicas ya filtradas
	text = "''" + p_nombre + "''" + "\n" +\
	"" + "\n" + "NV  " + str(p_nv) + "\n" +\
	"PS  " + str(p_vida) + " / " + str(p_vida_max) +\
	"\n" + "" + "\n" + "AT  " + str(p_atq) + " (" + str(p_atq_extra) + ")" + "                    " + "PE:  " + str(Global.PE if "PE" in Global else 0) + "\n" +\
	"DF  " + str(p_def) + " (" + str(p_def_extra) + ")" + "                    " + "LV:  " + str(Global.LV if "LV" in Global else 1) + "\n" +\
	"\n" + "ARMA: " + nombre_arma + "\n" +\
	"ARMADURA: " + nombre_armadura
