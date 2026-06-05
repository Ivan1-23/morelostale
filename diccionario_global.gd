extends Node

# --- CONFIGURACIÓN DE PARTIDA ---
var inicio_correcto: bool = true
var moviste_archivos_para_estar_en_la_habitación_debug: bool = false

# --- INVENTARIO ACTUAL ---
var inventario: Array = ["sandwich_normal", "gorra_ilegal"]
# --- BASE DE DATOS DE OBJETOS COMPLETA ---
const BASE_DE_DATOS_OBJETOS = {
	"torta": {
		"nombre": "Torta",
		"hp": 30,
		"precio": 50,
		"tipo": "objeto curativo",
		"descripcion": "Cura 30 HP.\nEs de jamón."
	},
	"lata_jugo": {
		"nombre": "LataJugo",
		"hp": 15,
		"precio": 25,
		"tipo": "objeto curativo",
		"descripcion": "Cura 15 HP.\nRefrescante jugo."
	},
	"dulce": {
		"nombre": "Dulce",
		"hp": 10,
		"precio": 10,
		"tipo": "objeto curativo",
		"descripcion": "Cura 10 HP.\nTe da energía."
	},
	"pluma_azul": {
		"nombre": "PlumaAzul",
		"atq": 4,
		"def": 0,
		"precio": 30,
		"tipo": "Arma",
		"descripcion": "Arma (ATQ +4).\nUna pluma ligera."
	},
	"borrador": {
		"nombre": "Borrador",
		"atq": 0,
		"def": 4,
		"precio": 25,
		"tipo": "Armadura",
		"descripcion": "Armadura (DEF +4).\nBorra los errores."
	},
	"curita": {
		"nombre": "Curita",
		"hp": 10,
		"precio": 15,
		"tipo": "objetivo curativo", # Respetando tu texto
		"descripcion": "Cura 10 HP.\nCubre heridas ligeras."
	},
	"medicina_amarga": {
		"nombre": "MedicinaAmarga",
		"hp": 12,
		"precio": 0, # n/a en tu lista, le ponemos 0 por defecto
		"tipo": "objetivo curativo",
		"descripcion": "Cura 12 HP.\nEl sabor te desagrada."
	},
	"sandwich_normal": {
		"nombre": "SandwichNormal",
		"hp": 8,
		"precio": 25,
		"tipo": "objetivo curativo",
		"descripcion": "Cura 8 HP.\nSe puede partir en 3."
	},
	"lonche_raro": {
		"nombre": "LoncheRaro",
		"hp": 18,
		"precio": 20,
		"tipo": "objeto curativo",
		"descripcion": "Cura 18 HP.\nHuele algo extraño."
	},
	"tijeras_escolares": {
		"nombre": "TijerasEscolares",
		"atq": 8,
		"def": 2,
		"precio": 40,
		"tipo": "Arma",
		"descripcion": "Arma (ATQ +8, DEF +2).\nSon afiladas."
	},
	"sudadera_olvidada": {
		"nombre": "SudaderaAband",
		"atq": 0,
		"def": 20,
		"precio": 150,
		"tipo": "Armadura",
		"descripcion": "Armadura (DEF +20).\nCómoda y abrigadora."
	},
	"chicle": {
		"nombre": "Chicle",
		"hp": 5,
		"precio": 5,
		"tipo": "objeto curativo",
		"descripcion": "Cura 5 HP.\nSabor duradero."
	},
	"bolsa_de_papas": {
		"nombre": "BolsaDePapas",
		"hp": 14,
		"precio": 20,
		"tipo": "objeto curativo",
		"descripcion": "Cura 14 HP\nCrujientes papitas"
	},
	"plumon_negro": {
		"nombre": "PlumónNegro",
		"atq": 5,
		"def": 0,
		"precio": 35,
		"tipo": "Arma",
		"descripcion": "Arma (ATQ +5)\nTinta permanente"
	},
	"gorra_ilegal": {
		"nombre": "GorraIlegal",
		"atq": 0,
		"def": 6,
		"precio": 50,
		"tipo": "Armadura",
		"descripcion": "Armadura (DEF +6)\nTe da estilo criminal"
	},
	"lapiz_inicial":{
		"nombre": "lapiz",
		"atq": 3,
		"def": 0,
		"precio": 0,
		"tipo": "Arma",
		"descripcion": "Arma (ATQ +3)\nEs mejor para bocetos"
	}
}

# --- FUNCIONES DE GESTIÓN DE INVENTARIO ---
func añadir_objeto(id_objeto: String) -> bool:
	if inventario.size() < 8:
		if id_objeto in BASE_DE_DATOS_OBJETOS:
			inventario.append(id_objeto)
			return true
	return false

func eliminar_objeto_por_indice(indice: int):
	if indice >= 0 and indice < inventario.size():
		inventario.remove_at(indice)
