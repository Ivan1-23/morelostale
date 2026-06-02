extends CanvasLayer

signal dialogo_terminado

@onready var texto_label = $Fondo/Contenedor/Texto
@onready var retrato = $Fondo/Contenedor/Retrato
@onready var timer = $TimerEfecto
@onready var audio_voz = $AudioVoz


var lineas_dialogo: Array = []
var linea_actual: int = 0
var escribiendo: bool = false

func _ready():
	visible = false

func iniciar_dialogo(datos_dialogo: Array):
	# Formato esperado: [{"texto": "* Hola humano.", "retrato": null, "voz": stream_audio}]
	lineas_dialogo = datos_dialogo
	linea_actual = 0
	visible = true
	mostrar_linea()

func mostrar_linea():
	if linea_actual >= lineas_dialogo.size():
		finalizar_dialogo()
		return
		
	escribiendo = true
	texto_label.visible_characters = 0
	
	var datos = lineas_dialogo[linea_actual]
	texto_label.text = datos.get("texto", "")
	
	# --- LÓGICA DINÁMICA DE RETRATO Y SEPARACIÓN ---
	var contenedor = $Fondo/Contenedor
	
	if datos.get("retrato") != null:
		retrato.texture = datos["retrato"]
		retrato.visible = true
		# Si hay retrato, ponemos la separación que quieras (por ejemplo, 16 píxeles)
		contenedor.add_theme_constant_override("separation", 16)
	else:
		retrato.visible = false
		# Si NO hay retrato, forzamos la separación a 0 para que no deje un hueco vacío
		contenedor.add_theme_constant_override("separation", 0)
		
	if datos.get("voz") != null:
		audio_voz.stream = datos["voz"]
	
	timer.start()

func _on_timer_efecto_timeout():
	if texto_label.visible_characters < texto_label.get_total_character_count():
		texto_label.visible_characters += 1
		# Reproducir sonido de voz (evitamos que sature en los espacios vacíos)
		if texto_label.text[texto_label.visible_characters - 1] != " " and audio_voz.stream:
			audio_voz.play()
	else:
		timer.stop()
		escribiendo = false

func _input(event):
	if visible and event.is_action_pressed("acción"):
		if escribiendo:
			# El truco Undertale: si presionas "acción" mientras escribe, muestra todo de golpe
			timer.stop()
			texto_label.visible_characters = -1
			escribiendo = false
		else:
			# Si ya terminó de escribir, avanza a la siguiente línea
			linea_actual += 1
			mostrar_linea()

func finalizar_dialogo():
	visible = false
	emit_signal("dialogo_terminado")
