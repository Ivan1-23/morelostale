extends Node

# === VARIABLES GLOBALES (HÉROE 0 - LÍDER) ===
var nombre = "Sebo"
var NV = 1
var vidaMax = 20
var vida = 12
var ATQ = 0
var DEF = 0
var ATQ_extra = 0
var DEF_extra = 0
var arma_equipada: String = "lapiz_inicial"
var armadura_equipada: String = "borrador"

# === VARIABLES GLOBALES (HÉROE 1) ===
var nombre_p1 = "Smuffy"
var nv_p1 = 1
var vida_max_p1 = 30
var vida_p1 = 30
var ATQ_p1 = 0
var DEF_p1 = 0
var ATQ_extra_p1 = 0
var DEF_extra_p1 = 0
var arma_p1: String = ""       
var armadura_p1: String = ""   

# === VARIABLES GLOBALES (HÉROE 2) ===
var nombre_p2 = "Arisa"
var nv_p2 = 1
var vida_max_p2 = 18
var vida_p2 = 18
var ATQ_p2 = 0
var DEF_p2 = 0
var ATQ_extra_p2 = 0
var DEF_extra_p2 = 0
var arma_p2: String = ""       # ID del arma de Ralsei
var armadura_p2: String = ""   # ID de la armadura de Ralsei

# Otras variables que compartes en todo el juego
var PE = 0
var LV = 1
var oro = 0
var sig = 10
var lista_objetos = ["objeto1","objeto2","objeo3","objeto4","objeto5","objeto6","objeto7","objeto8"]
var inicio_correcto: bool = false
var moviste_archivos_para_estar_en_la_habitación_debug: bool = false

func _ready() -> void:
	actualizar_equipamiento()

# MODIFICACIÓN: Ahora calcula los modificadores de los 3 héroes consultando el diccionario_global
func actualizar_equipamiento() -> void:
	ATQ_extra = 0
	DEF_extra = 0
	ATQ_extra_p1 = 0
	DEF_extra_p1 = 0
	ATQ_extra_p2 = 0
	DEF_extra_p2 = 0
	
	var base_datos = diccionario_global.BASE_DE_DATOS_OBJETOS
	
	# --- CÁLCULOS PERSONAJE 0 (LÍDER) ---
	if arma_equipada != "" and base_datos.has(arma_equipada):
		ATQ_extra += base_datos[arma_equipada].get("atq", 0)
		DEF_extra += base_datos[arma_equipada].get("def", 0)
	if armadura_equipada != "" and base_datos.has(armadura_equipada):
		ATQ_extra += base_datos[armadura_equipada].get("atq", 0)
		DEF_extra += base_datos[armadura_equipada].get("def", 0)
		
	# --- CÁLCULOS PERSONAJE 1 ---
	if arma_p1 != "" and base_datos.has(arma_p1):
		ATQ_extra_p1 += base_datos[arma_p1].get("atq", 0)
		DEF_extra_p1 += base_datos[arma_p1].get("def", 0)
	if armadura_p1 != "" and base_datos.has(armadura_p1):
		ATQ_extra_p1 += base_datos[armadura_p1].get("atq", 0)
		DEF_extra_p1 += base_datos[armadura_p1].get("def", 0)
		
	# --- CÁLCULOS PERSONAJE 2 ---
	if arma_p2 != "" and base_datos.has(arma_p2):
		ATQ_extra_p2 += base_datos[arma_p2].get("atq", 0)
		DEF_extra_p2 += base_datos[arma_p2].get("def", 0)
	if armadura_p2 != "" and base_datos.has(armadura_p2):
		ATQ_extra_p2 += base_datos[armadura_p2].get("atq", 0)
		DEF_extra_p2 += base_datos[armadura_p2].get("def", 0)
