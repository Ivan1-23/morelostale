extends CanvasLayer

# --- REFERENCIAS A NODOS ---
@onready var menu_principal = $MenuPrincipal
@onready var panel_mini_stats = $MenuPrincipal/PanelMiniStats
@onready var panel_comandos = $MenuPrincipal/PanelComandos
@onready var panel_accion = $MenuPrincipal/PanelAccion
@onready var corazon = $MenuPrincipal/Corazon

# Etiquetas de Mini Stats
@onready var lbl_nombre = $MenuPrincipal/PanelMiniStats/LabelNombre
@onready var lbl_hp = $MenuPrincipal/PanelMiniStats/LabelPS
@onready var lbl_lv = $MenuPrincipal/PanelMiniStats/LabelNV
@onready var lbl_g = $MenuPrincipal/PanelMiniStats/LabelO

# --- VARIABLES DE ESTADO ---
var estado = "CERRADO" # CERRADO, COMANDOS, SELECCION_HEROE
var indice_seleccion = 0
var heroe_actual = 0 # 0, 1 o 2

func _ready():
	# Aseguramos que el menú inicie oculto
	menu_principal.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	# 1. ABRIR / CERRAR (Tecla C)
	if event.is_action_pressed("menu"):
		if estado == "CERRADO":
			abrir_menu()
		else:
			cerrar_menu()
	
	if estado == "CERRADO": return

	# 2. NAVEGACIÓN (Flechas)
	if event.is_action_pressed("ui_up"):
		cambiar_indice(-1)
	elif event.is_action_pressed("ui_down"):
		cambiar_indice(1)

	# 3. ACCIONES (Z / Enter y X / Esc)
	if event.is_action_pressed("acción"):
		confirmar_seleccion()
	elif event.is_action_pressed("correr"):
		volver_atras()

# --- FUNCIONES DE CONTROL ---

func abrir_menu():
	estado = "COMANDOS"
	menu_principal.show()
	panel_accion.hide()
	indice_seleccion = 0
	actualizar_visual_mini_stats()
	posicionar_corazon()
	get_tree().paused = true # Pausa el movimiento del jugador

func cerrar_menu():
	estado = "CERRADO"
	menu_principal.hide()
	get_tree().paused = false # Reanuda el juego

func actualizar_visual_mini_stats():
	# Leemos los datos directos del script Global
	var datos = Global.personajes[heroe_actual]
	lbl_nombre.text = datos["nombre"]
	lbl_lv.text = "NV " + str(datos["lv"])
	lbl_hp.text = "PS %d/%d" % [datos["hp"], datos["max_hp"]]
	lbl_g.text = "O  " + str(Global.oro_total)

func cambiar_indice(valor):
	var limite = 3 # 3 opciones en comandos o 3 héroes
	indice_seleccion = posmod(indice_seleccion + valor, limite)
	
	# Si estamos eligiendo héroe, actualizamos los stats mientras navegamos
	if estado == "SELECCION_HEROE":
		heroe_actual = indice_seleccion
		actualizar_visual_mini_stats()
	
	posicionar_corazon()

func posicionar_corazon():
	var nodo_objetivo
	if estado == "COMANDOS":
		# Buscamos en el VBoxContainer de ITEM, STAT, CELL
		nodo_objetivo = panel_comandos.get_node("VBoxContainer").get_child(indice_seleccion)
	else:
		# Buscamos en el panel de la derecha (donde estarían los nombres de los 3)
		nodo_objetivo = panel_accion.get_node("VBoxPersonajes").get_child(indice_seleccion)
	
	corazon.global_position = Vector2(nodo_objetivo.global_position.x - 20, nodo_objetivo.global_position.y + 12)

func confirmar_seleccion():
	if estado == "COMANDOS":
		if indice_seleccion == 1: # Eligió STAT
			estado = "SELECCION_HEROE"
			panel_accion.show()
			indice_seleccion = heroe_actual
			posicionar_corazon()
		# Aquí añadirías lógica para ITEM o CELL

func volver_atras():
	if estado == "SELECCION_HEROE":
		estado = "COMANDOS"
		panel_accion.hide()
		indice_seleccion = 1 # Regresa el foco a "STAT"
		posicionar_corazon()
	else:
		cerrar_menu()
