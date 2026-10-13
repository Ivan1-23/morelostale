extends Node

const RUTA_ARCHIVO = "user://partida_guardada.save"

# --- DICCIONARIO MAESTRO DE DATOS ---
var datos_partida = {
	# Información de la escena y ubicación
	"habitacion_actual": "res://mapas/habitacion_inicio.tscn",
	"posicion_jugador": {"x": 0.0, "y": 0.0},
	"zona_actual": "Ruinas",
	"subzona_actual": "Pasillo Principal",
	
	# Progreso e información de partida
	"tiempo_jugado_segundos": 0.0,
	"vida_actual": 100,
	"vida_maxima": 100,
	"NV": 1,
	
	# Estado de seguidores (Deltarune-style)
	"seguidores": {
		"smuffy": false,
		"arisa": false
	},
	
	# Inventario y Cajas Dimensionales
	"inventario": [],
	"cajas_dimensionales": {},
	
	# Banderas de eventos, cinemáticas y diálogos vistos (Flags)
	"flags_eventos": {}
}

# --- CONTADOR DE TIEMPO DE JUEGO ---
func _process(delta: float) -> void:
	# Suma el tiempo de juego continuamente mientras el juego no esté pausado
	datos_partida["tiempo_jugado_segundos"] += delta

# --- GUARDAR PARTIDA ---
func guardar_partida() -> void:
	# 1. Recolectar el estado actual del mundo antes de escribir al archivo
	_recolectar_datos_actuales()
	
	# 2. Abrir archivo en modo escritura (compatible con PC e Itch.io)
	var archivo = FileAccess.open(RUTA_ARCHIVO, FileAccess.WRITE)
	if archivo:
		var datos_bytes = var_to_bytes(datos_partida)
		archivo.store_buffer(datos_bytes)
		archivo.close()
		print("¡Partida guardada correctamente en user://!")
	else:
		print("Error al intentar guardar la partida.")

# --- CARGAR PARTIDA ---
func cargar_partida() -> bool:
	if not FileAccess.file_exists(RUTA_ARCHIVO):
		print("No existe archivo de guardado previo.")
		return false

	var archivo = FileAccess.open(RUTA_ARCHIVO, FileAccess.READ)
	if archivo:
		var datos_bytes = archivo.get_buffer(archivo.get_length())
		archivo.close()
		
		var datos_cargados = bytes_to_var(datos_bytes)
		if typeof(datos_cargados) == TYPE_DICTIONARY:
			datos_partida = datos_cargados
			_aplicar_datos_al_mundo()
			print("¡Partida cargada con éxito!")
			return true
	
	print("Error al leer el archivo de guardado.")
	return false

# --- RECOLECTAR DATOS DEL JUEGO ANTES DE GUARDAR ---
func _recolectar_datos_actuales() -> void:
	# Jugador
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		datos_partida["posicion_jugador"] = {
			"x": jugador.global_position.x,
			"y": jugador.global_position.y
		}
		if "vida" in jugador:
			datos_partida["vida_actual"] = jugador.vida

	# Seguidores (Smuffy y Arisa)
	var smuffy = get_tree().get_first_node_in_group("smuffy")
	if smuffy and "ya_se_unio" in smuffy:
		datos_partida["seguidores"]["smuffy"] = smuffy.ya_se_unio

	var arisa = get_tree().get_first_node_in_group("arisa")
	if arisa and "ya_se_unio" in arisa:
		datos_partida["seguidores"]["arisa"] = arisa.ya_se_unio

# --- APLICAR DATOS AL MUNDO TRAS CARGAR ---
func _aplicar_datos_al_mundo() -> void:
	# Reposicionar jugador
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		jugador.global_position = Vector2(
			datos_partida["posicion_jugador"]["x"],
			datos_partida["posicion_jugador"]["y"]
		)
		if "vida" in jugador:
			jugador.vida = datos_partida["vida_actual"]

	# Reorganizar seguidores
	var smuffy = get_tree().get_first_node_in_group("smuffy")
	if smuffy and datos_partida["seguidores"]["smuffy"]:
		smuffy.ya_se_unio = true
		if jugador:
			smuffy.empezar_a_seguir(jugador)

	var arisa = get_tree().get_first_node_in_group("arisa")
	if arisa and datos_partida["seguidores"]["arisa"]:
		arisa.ya_se_unio = true
		if smuffy:
			arisa.empezar_a_seguir(smuffy)

# --- FUNCIONES DE UTILIDAD PARA BANDERAS/FLAGS ---
func establecer_flag(clave: String, valor: bool) -> void:
	datos_partida["flags_eventos"][clave] = valor

func obtener_flag(clave: String) -> bool:
	return datos_partida["flags_eventos"].get(clave, false)
