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
	
	match heroe_id:
		0:
			p_nombre = Global.nombre_p0 if "nombre_p0" in Global else Global.nombre
			p_nv = Global.NV
			p_vida = Global.vida
			p_vida_max = Global.vidaMax
		1:
			p_nombre = Global.nombre_p1 if "nombre_p1" in Global else "Susie"
			p_nv = Global.NV_p1 if "NV_p1" in Global else Global.NV
			p_vida = Global.vida_p1 if "vida_p1" in Global else 30
			p_vida_max = Global.vida_max_p1 if "vida_max_p1" in Global else 30
		2:
			p_nombre = Global.nombre_p2 if "nombre_p2" in Global else "Ralsei"
			p_nv = Global.NV_p2 if "NV_p2" in Global else Global.NV
			p_vida = Global.vida_p2 if "vida_p2" in Global else 15
			p_vida_max = Global.vida_max_p2 if "vida_max_p2" in Global else 15

	var id_arma = Global.arma_equipada
	var id_armadura = Global.armadura_equipada
	
	var datos_arma = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_arma, {})
	var datos_armadura = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_armadura, {})
	
	var nombre_arma = datos_arma.get("nombre", "Ninguna")
	var nombre_armadura = datos_armadura.get("nombre", "Ninguna")
	
	# 4. Pintamos la pantalla con las variables del personaje elegido
	text = "''" + p_nombre + "''" + "\n" +\
	"" + "\n" + "NV  " + str(p_nv) + "\n" +\
	"PS  " + str(p_vida) + " / " + str(p_vida_max) +\
	"\n" + "" + "\n" + "AT  " + str(Global.ATQ) + " (" + str(Global.ATQ_extra) + ")" + "                    " + "PE:  " + str(Global.PE) + "\n" +\
	"DF  " + str(Global.DEF) + " (" + str(Global.DEF_extra) + ")" + "                    " + "LV:  " + str(Global.LV) + "\n" +\
	"\n" + "ARMA: " + nombre_arma + "\n" +\
	"ARMADURA: " + nombre_armadura
