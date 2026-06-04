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
	# IMPORTANTE: Aquí activamos la bandera de seguridad que planeamos antes
	#Global.inicio_correcto = true
	#actualizar_menu()

func _input(event):
	# Movimiento Arriba/Abajo
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		opcion_seleccionada = 1 - opcion_seleccionada # Alterna entre 0 y 1
		actualizar_menu()
	
	# Confirmar con Z
	if event.is_action_pressed("acción"):
		sonido_seleccion.play()
		seleccionar_opcion()

func actualizar_menu():
	# Resetear ambos a blanco
	label_jugar.modulate = Color.WHITE
	label_settings.modulate = Color.WHITE
	
	# El seleccionado se pone AMARILLO (Como en la imagen)
	if opcion_seleccionada == 0:
		label_jugar.modulate = Color.YELLOW
	else:
		label_settings.modulate = Color.YELLOW

func seleccionar_opcion():
	if opcion_seleccionada == 0:
		# Cambia a tu primera habitación real
		get_tree().change_scene_to_file("res://mapa_ejemplo_2.tscn")
	else:
		print("Abriendo ajustes...") # Aquí iría tu menú de opciones



# --- SEÑALES DE LOS BOTONES TÁCTILES ---

func _on_jugar_pressed() -> void:
	opcion_seleccionada = 0       # 1. Registra que se seleccionó Jugar
	actualizar_menu()             # 2. Pinta el texto de amarillo al instante
	sonido_seleccion.play()       # 3. Reproduce el sonido de confirmación
	
	# Esperamos los 0.45 segundos exactos del sonido antes de avanzar
	await get_tree().create_timer(0.25).timeout 
	seleccionar_opcion()          # 4. Cambia de escena

func _on_configuración_pressed() -> void:
	opcion_seleccionada = 1       # 1. Registra que se seleccionó Configuraciones
	actualizar_menu()             # 2. Pinta el texto de amarillo al instante
	sonido_seleccion.play()       # 3. Reproduce el sonido de confirmación
	
	# Esperamos el mismo tiempo para que se aprecie el cambio visual
	await get_tree().create_timer(0.25).timeout 
	seleccionar_opcion()          # 4. Ejecuta la opción
