extends RichTextLabel

func _ready() -> void:
	actualizar_estadisticas()

func actualizar_estadisticas() -> void:
	# 1. Aseguramos que antes de pintar, Global tenga los extras bien calculados
	if Global.has_method("actualizar_equipamiento"):
		Global.actualizar_equipamiento()
		
	# 2. Obtenemos las IDs desde 'Global'
	var id_arma = Global.arma_equipada
	var id_armadura = Global.armadura_equipada
	
	# 3. Buscamos los nombres en el diccionario
	var datos_arma = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_arma, {})
	var datos_armadura = diccionario_global.BASE_DE_DATOS_OBJETOS.get(id_armadura, {})
	
	var nombre_arma = datos_arma.get("nombre", "Ninguna")
	var nombre_armadura = datos_armadura.get("nombre", "Ninguna")
	
	# 4. Pintamos la pantalla con el formato Base (Extra)
	text = "''" + Global.nombre + "''" + "\n" +\
	"" + "\n" + "NV  " + str(Global.NV) + "\n" +\
	"PS  " + str(Global.vida) + " / " + str(Global.vidaMax) +\
	"\n" + "" + "\n" + "AT  " + str(Global.ATQ) + " (" + str(Global.ATQ_extra) + ")" + "                    " + "PE:  " + str(Global.PE) +\
	"\n" + "DF  " + str(Global.DEF) + " (" + str(Global.DEF_extra) + ")"  + "                    " + "SIG:  " + str(Global.sig) +\
	"\n" + "" + "\n" + "ARMA: " + nombre_arma +\
	"\n" + "" + "ARMAD: " + nombre_armadura
