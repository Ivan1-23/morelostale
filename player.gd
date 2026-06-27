extends CharacterBody2D

# Ajustamos las velocidades exactas que definiste
@export var velocidad_caminar: float = 60.0
@export var velocidad_correr: float = 120.0
var en_dialogo: bool = false
@onready var animaciones = $CollisionShape2D/AnimatedSprite2D

# --- TU RAYCAST EXISTENTE ---
@onready var detector = $CollisionShape2D/RayCast2D 

# Esta es la variable clave que lee el menú y controla el estado del juego
var puede_moverse: bool = true

func _ready():
	# Añadimos al jugador al grupo "player" automáticamente
	add_to_group("player")

func _physics_process(_delta):
	# Si el menú o un diálogo bloqueó al jugador, lo detenemos por completo y salimos
	if not puede_moverse:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Movimiento normal en 4 direcciones
	var direccion = Vector2.ZERO
	direccion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direccion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if direccion != Vector2.ZERO:
		direccion = direccion.normalized()
		var es_corriendo = Input.is_action_pressed("correr")
		var velocidad_actual = velocidad_correr if es_corriendo else velocidad_caminar
			
		velocity = direccion * velocidad_actual
		
		# --- ROTACIÓN DINÁMICA DE TU RAYCAST ---
		if abs(direccion.x) > abs(direccion.y):
			detector.target_position = Vector2(15 if direccion.x > 0 else -15, 0)
		else:
			detector.target_position = Vector2(0, 15 if direccion.y > 0 else -15)
		
		# Control de animaciones con tus nombres exactos
		var prefijo = "run_" if es_corriendo else "mov_"
		
		if abs(direccion.x) > abs(direccion.y):
			if direccion.x > 0:
				animaciones.play(prefijo + "right")
			else:
				animaciones.play(prefijo + "left")
		else:
			if direccion.y > 0:
				animaciones.play(prefijo + "down")
			else:
				animaciones.play(prefijo + "top")
	else:
		velocity = Vector2.ZERO
		
		# Control de animaciones Idle al detenerse
		if animaciones.animation.begins_with("mov_") or animaciones.animation.begins_with("run_"):
			var direccion_actual = animaciones.animation.split("_")[1]
			animaciones.play("idle_" + direccion_actual)
			
	move_and_slide()

	if Input.is_action_just_pressed("acción"):
		if detector.is_colliding():
			var objeto_chocado = detector.get_collider()
			
			if objeto_chocado:
				# === FUNCIÓN INTERNA PARA DETENER LA ANIMACIÓN EN IDLE ===
				var frenar_animacion_en_idle = func():
					puede_moverse = false
					en_dialogo = true
					
					# Detectamos qué animación de movimiento o carrera tenía puesta para mantener la dirección
					if animaciones.animation.begins_with("mov_") or animaciones.animation.begins_with("run_"):
						var direccion_actual = animaciones.animation.split("_")[1] # Extrae 'down', 'left', 'right' o 'top'
						animaciones.play("idle_" + direccion_actual)
					else:
						# Si por alguna razón la animación ya era un idle o algo raro, aseguramos que no se mueva
						animaciones.stop()

				# CASO 1: Es un objeto recolectable 
				if objeto_chocado.has_method("interactuar"):
					var cuadro_dialogo = owner.get_node_or_null("cuadro_dialogo")
					if not cuadro_dialogo:
						cuadro_dialogo = get_tree().get_first_node_in_group("dialogo")
						
					if cuadro_dialogo:
						frenar_animacion_en_idle.call() # <--- Pone al personaje en idle_dirección y bloquea el movimiento
						
						if not cuadro_dialogo.dialogo_terminado.is_connected(_on_dialogo_terminado):
							cuadro_dialogo.dialogo_terminado.connect(_on_dialogo_terminado)
						
						objeto_chocado.interactuar(self)
				
				# CASO 2: Es un letrero o NPC común
				elif objeto_chocado.has_method("hablar"):
					var cuadro_dialogo = owner.get_node_or_null("cuadro_dialogo")
					if not cuadro_dialogo:
						cuadro_dialogo = get_tree().get_first_node_in_group("dialogo")
					
					if cuadro_dialogo:
						frenar_animacion_en_idle.call() # <--- Pone al personaje en idle_dirección y bloquea el movimiento
						
						if not cuadro_dialogo.dialogo_terminado.is_connected(_on_dialogo_terminado):
							cuadro_dialogo.dialogo_terminado.connect(_on_dialogo_terminado)
						
						cuadro_dialogo.iniciar_dialogo(objeto_chocado.hablar())

# Modificamos tu función de cierre para avisar que el diálogo terminó:
func _on_dialogo_terminado():
	await get_tree().create_timer(0.15).timeout
	puede_moverse = true
	en_dialogo = false
