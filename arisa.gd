extends CharacterBody2D

# --- CONFIGURACIÓN DEL PERSONAJE ---
@export var nombre_personaje: String = "Coprotagonista"
@export var retraso_pasos: int = 18 # Separación con el líder de enfrente
@export var esta_siguiendo: bool = false
@export var objetivo: Node2D = null

# --- REFERENCIAS A NODOS ---
@onready var animaciones: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D
@onready var detector: RayCast2D = $CollisionShape2D/RayCast2D
@onready var colision: CollisionShape2D = $CollisionShape2D

# --- HISTORIAL PROPIO (Para que otros seguidores puedan seguir a este personaje) ---
var historial_pasos: Array = []
const MAX_HISTORIAL: int = 100
var ya_se_unio: bool = false

func _ready() -> void:
	# Aseguramos que el RayCast empiece apuntando hacia abajo
	if detector:
		detector.target_position = Vector2(0, 15)

func _physics_process(_delta: float) -> void:
	if not esta_siguiendo or not objetivo:
		return

	# Leemos el historial de pasos del personaje de enfrente
	if "historial_pasos" in objetivo and objetivo.historial_pasos.size() > retraso_pasos:
		var paso_guardado = objetivo.historial_pasos[retraso_pasos]
		var posicion_destino: Vector2 = paso_guardado["pos"]
		var animacion_destino: String = paso_guardado["anim"]

		# Si hay distancia, el seguidor camina hacia ese punto
		if global_position.distance_to(posicion_destino) > 2.0:
			global_position = posicion_destino
			animaciones.play(animacion_destino)
			
			# Orientamos el RayCast dinámicamente según la animación actual
			_actualizar_orientacion_raycast(animacion_destino)

			# Guardamos nuestra propia posición y animación para el siguiente seguidor
			historial_pasos.insert(0, {"pos": global_position, "anim": animaciones.animation})
			if historial_pasos.size() > MAX_HISTORIAL:
				historial_pasos.pop_back()
		else:
			# Al llegar al punto, cambia a animación idle manteniendo la dirección
			if animaciones.animation.begins_with("mov_") or animaciones.animation.begins_with("run_"):
				var dir_actual = animaciones.animation.split("_")[1]
				animaciones.play("idle_" + dir_actual)

# --- ROTACIÓN DINÁMICA DEL RAYCAST ---
func _actualizar_orientacion_raycast(nombre_anim: String) -> void:
	if not detector:
		return
	
	if "right" in nombre_anim:
		detector.target_position = Vector2(15, 0)
	elif "left" in nombre_anim:
		detector.target_position = Vector2(-15, 0)
	elif "down" in nombre_anim:
		detector.target_position = Vector2(0, 15)
	elif "top" in nombre_anim:
		detector.target_position = Vector2(0, -15)

# --- SISTEMA DE DIÁLOGO (Llamado por player.gd) ---
func hablar() -> Array:
	# 1. Girar al personaje hacia Sebo antes de hablar
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		var dir_relativa = jugador.global_position - global_position
		if abs(dir_relativa.x) > abs(dir_relativa.y):
			if dir_relativa.x > 0:
				animaciones.play("idle_right")
				if detector: detector.target_position = Vector2(15, 0)
			else:
				animaciones.play("idle_left")
				if detector: detector.target_position = Vector2(-15, 0)
		else:
			if dir_relativa.y > 0:
				animaciones.play("idle_down")
				if detector: detector.target_position = Vector2(0, 15)
			else:
				animaciones.play("idle_top")
				if detector: detector.target_position = Vector2(0, -15)

	# 2. Conectar las señales con el cuadro de diálogo
	var cuadro_dialogo = owner.get_node_or_null("cuadro_dialogo")
	if not cuadro_dialogo:
		cuadro_dialogo = get_tree().get_first_node_in_group("dialogo")

	if cuadro_dialogo and not ya_se_unio:
		if not cuadro_dialogo.respuesta_pregunta.is_connected(_on_respuesta_recibida):
			cuadro_dialogo.respuesta_pregunta.connect(_on_respuesta_recibida, CONNECT_ONE_SHOT)

	# 3. Retornar el diálogo interactivo
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
				"texto": "* Arisa y Smuffy se unen al equipo",
				"retrato": null,
				"voz": null,
				"es_pregunta": false
			}
		]

# --- RESPUESTA DEL DIÁLOGO Y ACTIVACIÓN ---
func _on_respuesta_recibida(acepto: bool) -> void:
	if acepto and not ya_se_unio:
		ya_se_unio = true
		
		# Buscar a quién debe seguir
		var jugador = get_tree().get_first_node_in_group("player")
		if jugador:
			empezar_a_seguir(jugador)

func empezar_a_seguir(nuevo_objetivo: Node2D) -> void:
	objetivo = nuevo_objetivo
	esta_siguiendo = true
	
	# Desactivar colisión física para evitar colisiones y bloqueos
	if colision:
		colision.disabled = true
