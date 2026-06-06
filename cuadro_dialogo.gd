extends CanvasLayer

signal dialogo_terminado
signal respuesta_pregunta(acepto: bool)

@onready var texto_label = $Fondo/Contenedor/Texto
@onready var retrato = $Fondo/Contenedor/Retrato
@onready var timer = $Fondo/TimerEfecto
@onready var audio_voz = $Fondo/AudioVoz
@onready var corazon_pregunta = $Fondo/AlmaPregunta
@onready var boton_si = $Fondo/BotonSi
@onready var boton_no = $Fondo/BotonNo
var sonido_squeak = AudioStreamPlayer.new()

var lineas_dialogo: Array = []
var linea_actual: int = 0
var escribiendo: bool = false
var es_pregunta: bool = false

var opcion_pregunta: int = 0 # 0 = SÍ, 1 = NO
var posicion_x_si: float = 70 
var posicion_x_no: float = 170
var posicion_y_opciones: float = 100

func _ready():
	visible = false
	timer.wait_time = 0.03
	corazon_pregunta.visible = false
	add_child(sound_setup())
	if DisplayServer.is_touchscreen_available():
		boton_si.visible = false
		boton_no.visible = false
func sound_setup() -> AudioStreamPlayer:
	sonido_squeak.stream = load("res://audio/Interfaz/snd_squeak.wav")
	return sonido_squeak

func iniciar_dialogo(datos_dialogo: Array):
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
	corazon_pregunta.visible = false
	
	var datos = lineas_dialogo[linea_actual]
	texto_label.text = datos.get("texto", "")
	es_pregunta = datos.get("es_pregunta", false)
	
	# --- LÓGICA DINÁMICA DE RETRATO CORREGIDA ---
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
		audio_voz.stream = load("res://audio/voces/SND_TXT1.wav")
	
	timer.start()

func _on_timer_efecto_timeout():
	if texto_label.visible_characters < texto_label.get_total_character_count():
		texto_label.visible_characters += 1
		if texto_label.text[texto_label.visible_characters - 1] != " " and audio_voz.stream:
			audio_voz.play()
	else:
		timer.stop()
		escribiendo = false
		
		if es_pregunta:
			opcion_pregunta = 0
			actualizar_posicion_corazon()
			corazon_pregunta.visible = true
# --- FUNCIONES DE LOS BOTONES TÁCTILES ---
func _on_boton_si_pressed():
	if not escribiendo and es_pregunta:
		opcion_pregunta = 0
		actualizar_posicion_corazon()
		confirmar_respuesta(true)

func _on_boton_no_pressed():
	if not escribiendo and es_pregunta:
		opcion_pregunta = 1
		actualizar_posicion_corazon()
		confirmar_respuesta(false)

func confirmar_respuesta(acepto: bool):
	corazon_pregunta.visible = false
	boton_si.visible = false
	boton_no.visible = false
	emit_signal("respuesta_pregunta", acepto)
	finalizar_dialogo()
func actualizar_posicion_corazon():
	if opcion_pregunta == 0:
		corazon_pregunta.position = Vector2(posicion_x_si, posicion_y_opciones)
	else:
		corazon_pregunta.position = Vector2(posicion_x_no, posicion_y_opciones)

func _input(event):
	if not visible:
		return

	if escribiendo:
		if event.is_action_pressed("correr"):
			timer.stop()
			texto_label.visible_characters = -1
			escribiendo = false
			
			if es_pregunta:
				opcion_pregunta = 0
				actualizar_posicion_corazon()
				corazon_pregunta.visible = true
		return

	if es_pregunta:
		if event.is_action_pressed("ui_menu_right") and opcion_pregunta == 0:
			if sonido_squeak: sonido_squeak.play()
			opcion_pregunta = 1
			actualizar_posicion_corazon()
			
		elif event.is_action_pressed("ui_menu_left") and opcion_pregunta == 1:
			if sonido_squeak: sonido_squeak.play()
			opcion_pregunta = 0
			actualizar_posicion_corazon()
			
		elif event.is_action_pressed("acción"):
			corazon_pregunta.visible = false
			if opcion_pregunta == 0:
				emit_signal("respuesta_pregunta", true)
			else:
				emit_signal("respuesta_pregunta", false)
			finalizar_dialogo()
	else:
		if event.is_action_pressed("acción"):
			linea_actual += 1
			mostrar_linea()

func finalizar_dialogo():
	visible = false
	corazon_pregunta.visible = false
	emit_signal("dialogo_terminado")
