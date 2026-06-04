extends Control

var opcion_seleccionada = 0 # 0 = Begin Game, 1 = Settings

@onready var label_jugar = $"Opciones/Begin Game"
@onready var label_settings = $"Opciones/Settings"
@onready var btn_jugar = $"VBoxContainer2/jugar"
@onready var btn_configuraciones = $"VBoxContainer2/configuración"
@onready var sonido_seleccion = $"selección"

func _ready():
	if OS.has_feature("windows") or OS.has_feature("web_windows"):
		btn_jugar.visible = false
		btn_configuraciones.visible = false
		sonido_seleccion.stream = load("res://audio/Interfaz/undertale-select-sound.wav")
	
	# SOLUCIÓN 1: Llamamos a la función al iniciar para que "Begin Game" empiece amarillo
	actualizar_menu()

func _input(event):
	# Movimiento Arriba/Abajo
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		opcion_seleccionada = 1 - opcion_seleccionada # Alterna entre 0 y 1
		actualizar_menu()
	
	# Confirmar con Z / Acción
	if event.is_action_pressed("acción"):
		sonido_seleccion.play()
		# SOLUCIÓN 2: Esperamos a que suene el audio antes de destruir la escena en PC
		await get_tree().create_timer(0.25).timeout
		seleccionar_opcion()

func actualizar_menu():
	# Resetear ambos a blanco
	label_jugar.modulate = Color.WHITE
	label_settings.modulate = Color.WHITE
	
	# El seleccionado se pone AMARILLO
	if opcion_seleccionada == 0:
		label_jugar.modulate = Color.YELLOW
	else:
		label_settings.modulate = Color.YELLOW

func seleccionar_opcion():
	if opcion_seleccionada == 0:
		get_tree().change_scene_to_file("res://mapa_ejemplo_2.tscn")
	else:
		print("Abriendo ajustes...")


# --- SEÑALES DE LOS BOTONES TÁCTILES ---

func _on_jugar_pressed() -> void:
	opcion_seleccionada = 0       
	actualizar_menu()             
	sonido_seleccion.play()       
	
	await get_tree().create_timer(0.25).timeout 
	seleccionar_opcion()          

func _on_configuración_pressed() -> void:
	opcion_seleccionada = 1       
	actualizar_menu()             
	sonido_seleccion.play()       
	
	await get_tree().create_timer(0.25).timeout 
	seleccionar_opcion()
