extends CanvasLayer

signal dialogo_terminado

# Asegúrate de que los nombres de estos nodos coincidan exactamente con tu escena
@onready var texto_label = $Fondo/Contenedor/Texto
@onready var retrato = $Fondo/Contenedor/Retrato
@onready var timer = $Fondo/TimerEfecto
@onready var audio_voz = $Fondo/AudioVoz

var lineas_dialogo: Array = []
var linea_actual: int = 0
var escribiendo: bool = false

func _ready():
	visible = false
	timer.wait_time = 0.03
	visible = false

func iniciar_dialogo(datos_dialogo: Array):
	lineas_dialogo = datos_dialogo
	linea_actual = 0
	visible = true
	mostrar_linea()

func mostrar_linea():
	# Si ya pasamos la última frase, cerramos el cuadro
	if linea_actual >= lineas_dialogo.size():
		finalizar_dialogo()
		return
		
	escribiendo = true
	texto_label.visible_characters = 0
	
	# Extraemos la información de la línea actual
	var datos = lineas_dialogo[linea_actual]
	texto_label.text = datos.get("texto", "")
	
	# --- LÓGICA DINÁMICA DE RETRATO ---
	var contenedor = $Fondo/Contenedor
	if datos.get("retrato") != null:
		retrato.texture = datos["retrato"]
		retrato.visible = true
		contenedor.add_theme_constant_override("separation", 16)
	else:
		retrato.visible = false
		contenedor.add_theme_constant_override("separation", 0)
		
	# --- SISTEMA DE AUDIO DINÁMICO ---
	if datos.get("voz") != null:
		audio_voz.stream = datos["voz"]
	else:
		# Si el objeto no define una voz, carga el sonido de máquina de escribir por defecto
		# IMPORTANTE: Asegúrate de poner la ruta correcta de tu archivo de audio genérico aquí abajo
		audio_voz.stream = load("res://audio/voces/SND_TXT1.wav")
	
	# Encendemos el reloj para empezar a escribir letra por letra
	timer.start()

func _on_timer_efecto_timeout():
	if texto_label.visible_characters < texto_label.get_total_character_count():
		texto_label.visible_characters += 1
		
		# Hacemos sonar la voz, evitando que haga bips molestos en los espacios en blanco
		if texto_label.text[texto_label.visible_characters - 1] != " " and audio_voz.stream:
			audio_voz.play()
	else:
		# Si terminó de escribir toda la frase, detenemos el reloj
		timer.stop()
		escribiendo = false

func _input(event):
	# Si el cuadro no está en pantalla, ignoramos cualquier botón del teclado
	if not visible:
		return

	# --- BOTÓN CORRER (X): Únicamente completa el texto ---
	if event.is_action_pressed("correr"):
		if escribiendo:
			timer.stop()
			texto_label.visible_characters = -1
			escribiendo = false
		return # Corta el flujo aquí para que "correr" no haga nada más

	# --- BOTÓN ACCIÓN (Z): Pasa de página o cierra ---
	elif event.is_action_pressed("acción"):
		# Si está escribiendo, ignoramos la Z (así no se puede saltar el texto con este botón)
		if not escribiendo:
			linea_actual += 1
			mostrar_linea()
		return

func finalizar_dialogo():
	visible = false
	emit_signal("dialogo_terminado")
