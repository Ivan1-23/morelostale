extends CharacterBody2D

# --- CONFIGURACIÓN DEL PERSONAJE ---
@export var nombre_personaje: String = "Smuffy"
@export var sufijo_animacion: String = "_smuffy"
@export var retraso_pasos: int = 18 # Un poco más de margen para evitar que se pegue
@export var esta_siguiendo: bool = false
@export var objetivo: Node2D = null

# Ajusta estas velocidades para que coincidan con las de tu jugador
@export var velocidad_caminar: float = 60.0
@export var velocidad_correr: float = 120.0

# --- REFERENCIAS A NODOS ---
@onready var animaciones: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D
@onready var detector: RayCast2D = $CollisionShape2D/RayCast2D
@onready var colision: CollisionShape2D = $CollisionShape2D

# --- HISTORIAL PROPIO ---
var historial_pasos: Array = []
const MAX_HISTORIAL: int = 100
var ya_se_unio: bool = false

func _ready() -> void:
	if detector:
		detector.target_position = Vector2(0, 15)

func _physics_process(_delta: float) -> void:
	if not esta_siguiendo or not objetivo:
		return

	# 1. DISTANCIA DE FRENADO SEGURO
	var distancia_al_lider = global_position.distance_to(objetivo.global_position)
	if distancia_al_lider < 20.0:
		velocity = Vector2.ZERO
		move_and_slide()
		_detener_en_idle()
		return

	# 2. LECTURA DEL HISTORIAL
	if "historial_pasos" in objetivo and objetivo.historial_pasos.size() > retraso_pasos:
		var paso_guardado = objetivo.historial_pasos[retraso_pasos]
		var posicion_destino: Vector2 = paso_guardado["pos"]
		var animacion_objetivo: String = paso_guardado["anim"]

		var direccion = _extraer_direccion(animacion_objetivo)
		var es_corriendo = animacion_objetivo.begins_with("run_")
		var distancia_al_paso = global_position.distance_to(posicion_destino)

		if distancia_al_paso > 4.0:
			var velocidad_actual = velocidad_correr if es_corriendo else velocidad_caminar
			
			if distancia_al_paso > 50.0:
				velocidad_actual *= 1.3

			# === CORRECCIÓN ANTI-ATASCOS EN PAREDES ===
			# En lugar de apuntar milimétricamente al centro del punto, 
			# permitimos que el movimiento deslice con suavidad si choca con la geometría
			var dir_movimiento = global_position.direction_to(posicion_destino)
			velocity = dir_movimiento * velocidad_actual
			
			# move_and_slide maneja las colisiones por defecto, pero si se atascan 
			# contra una pared debido al desvío, la velocidad se ajusta para deslizarse
			move_and_slide()

			# Control de animaciones
			var prefijo = "run_" if es_corriendo else "mov_"
			var animacion_propia = prefijo + direccion + sufijo_animacion
			
			if animaciones.sprite_frames.has_animation(animacion_propia):
				if animaciones.animation != animacion_propia:
					animaciones.play(animacion_propia)
			
			_actualizar_orientacion_raycast(direccion)

			historial_pasos.insert(0, {"pos": global_position, "anim": animaciones.animation})
			if historial_pasos.size() > MAX_HISTORIAL:
				historial_pasos.pop_back()
		else:
			velocity = Vector2.ZERO
			move_and_slide()
			_detener_en_idle_con_direccion(direccion)
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		_detener_en_idle()


func _detener_en_idle() -> void:
	if animaciones.animation.begins_with("mov_") or animaciones.animation.begins_with("run_"):
		var dir = _extraer_direccion(animaciones.animation)
		_detener_en_idle_con_direccion(dir)

func _detener_en_idle_con_direccion(direccion: String) -> void:
	var anim_idle = "idle_" + direccion + sufijo_animacion
	if animaciones.sprite_frames.has_animation(anim_idle):
		if animaciones.animation != anim_idle:
			animaciones.play(anim_idle)

func _extraer_direccion(nombre_anim: String) -> String:
	if "right" in nombre_anim: return "right"
	if "left" in nombre_anim: return "left"
	if "top" in nombre_anim: return "top"
	return "down"

func _actualizar_orientacion_raycast(direccion: String) -> void:
	if not detector: return
	match direccion:
		"right": detector.target_position = Vector2(15, 0)
		"left": detector.target_position = Vector2(-15, 0)
		"down": detector.target_position = Vector2(0, 15)
		"top": detector.target_position = Vector2(0, -15)

# --- SISTEMA DE DIÁLOGO ---
func hablar() -> Array:
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		var dir_relativa = jugador.global_position - global_position
		var dir_mirar = "down"
		if abs(dir_relativa.x) > abs(dir_relativa.y):
			dir_mirar = "right" if dir_relativa.x > 0 else "left"
		else:
			dir_mirar = "down" if dir_relativa.y > 0 else "top"
			
		_detener_en_idle_con_direccion(dir_mirar)
		_actualizar_orientacion_raycast(dir_mirar)

	var cuadro_dialogo = owner.get_node_or_null("cuadro_dialogo")
	if not cuadro_dialogo:
		cuadro_dialogo = get_tree().get_first_node_in_group("dialogo")

	if cuadro_dialogo and not ya_se_unio:
		if not cuadro_dialogo.respuesta_pregunta.is_connected(_on_respuesta_recibida):
			cuadro_dialogo.respuesta_pregunta.connect(_on_respuesta_recibida, CONNECT_ONE_SHOT)

	if not ya_se_unio:
		return [
			{
				"texto": "* ¡Hola Sebo!\n(¿Quieres que se unan al equipo?)\n            SÍ              NO",
				"retrato": null,
				"voz": null,
				"es_pregunta": true
			}
		]
	else:
		return [
			{
				"texto": "* Smuffy está en el equipo.",
				"retrato": null,
				"voz": null,
				"es_pregunta": false
			}
		]

func _on_respuesta_recibida(acepto: bool) -> void:
	if acepto and not ya_se_unio:
		ya_se_unio = true
		
		# 1. Smuffy empieza a seguir a Sebo (el jugador)
		var jugador = get_tree().get_first_node_in_group("player")
		if jugador:
			empezar_a_seguir(jugador)
		
		# 2. Buscamos a Arisa mediante su grupo de forma segura
		var arisa = get_tree().get_first_node_in_group("arisa")
		if arisa and arisa.has_method("empezar_a_seguir"):
			arisa.ya_se_unio = true
			arisa.empezar_a_seguir(self) # Arisa empieza a seguir a Smuffy


func empezar_a_seguir(nuevo_objetivo: Node2D) -> void:
	objetivo = nuevo_objetivo
	esta_siguiendo = true
	if colision:
		colision.disabled = true
