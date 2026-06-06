extends CharacterBody2D

# Ajustamos las velocidades exactas que definiste
@export var velocidad_caminar: float = 60.0
@export var velocidad_correr: float = 120.0

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
		
		# Detectamos si está corriendo
		var es_corriendo = Input.is_action_pressed("correr")
		# Aplicamos tus velocidades exactas (60 o 120)
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

	# --- INTERACCIÓN MODIFICADA (LETREROS Y OBJETOS DEL SUELO) ---
	if Input.is_action_just_pressed("acción"):
		if detector.is_colliding():
			var objeto_chocado = detector.get_collider()
			
			if objeto_chocado:
				# CASO 1: Es un objeto recolectable (como el dulce)
				if objeto_chocado.has_method("interactuar"):
					# Buscamos el cuadro de diálogo para asegurar la conexión de cierre
					var cuadro_dialogo = owner.get_node_or_null("cuadro_dialogo")
					if not cuadro_dialogo:
						cuadro_dialogo = get_tree().get_first_node_in_group("dialogo")
						
					if cuadro_dialogo:
						# Nos conectamos a la señal para saber cuándo reactivar al jugador al terminar
						if not cuadro_dialogo.dialogo_terminado.is_connected(_on_dialogo_terminado):
							cuadro_dialogo.dialogo_terminado.connect(_on_dialogo_terminado)
						
						objeto_chocado.interactuar(self)
				
				# CASO 2: Es un letrero o NPC común
				elif objeto_chocado.has_method("hablar"):
					var cuadro_dialogo = owner.get_node_or_null("cuadro_dialogo")
					if not cuadro_dialogo:
						cuadro_dialogo = get_tree().get_first_node_in_group("dialogo")
					
					if cuadro_dialogo:
						puede_moverse = false 
						
						if not cuadro_dialogo.dialogo_terminado.is_connected(_on_dialogo_terminado):
							cuadro_dialogo.dialogo_terminado.connect(_on_dialogo_terminado)
						
						cuadro_dialogo.iniciar_dialogo(objeto_chocado.hablar())


# --- FUNCIÓN DE RETORNO (CALLBACK) ---
func _on_dialogo_terminado():
	await get_tree().create_timer(0.15).timeout
	puede_moverse = true
