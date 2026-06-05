extends Node
#variables globales
var ejemplo = "ejemplo"
var lista_objetos =["objeto1","objeto2","objeo3","objeto4","objeto5","objeto6","objeto7","objeto8"] 
var nombre = "jugador"
var vidaMax = 20
var vida = 12
var ATQ = 0
var DEF = 0
var ATQ_extra = 0
var DEF_extra = 0
var NV = 1
var PE = 0
var oro = 0
var sig = 10
var inicio_correcto: bool = false
var moviste_archivos_para_estar_en_la_habitación_debug: bool = false
var arma_equipada: String = "lapiz_inicial"
var armadura_equipada: String = "borrador"

func _ready() -> void:
	actualizar_equipamiento()
# Función para recalcular los stats extras según lo que esté equipado
func actualizar_equipamiento() -> void:
	# 1. Por defecto, si no hay nada puesto, el extra es 0
	ATQ_extra = 0
	DEF_extra = 0
	
	# 2. Consulta los datos de la base de datos de objetos
	var base_datos = diccionario_global.BASE_DE_DATOS_OBJETOS
	
	# --- CÁLCULO DEL ARMA ---
	if arma_equipada != "" and base_datos.has(arma_equipada):
		var datos_arma = base_datos[arma_equipada]
		ATQ_extra += datos_arma.get("atq", 0)
		DEF_extra += datos_arma.get("def", 0)
		
	# --- CÁLCULO DE LA ARMADURA ---
	if armadura_equipada != "" and base_datos.has(armadura_equipada):
		var datos_armadura = base_datos[armadura_equipada]
		DEF_extra += datos_armadura.get("def", 0)
		ATQ_extra += datos_armadura.get("atq", 0)
