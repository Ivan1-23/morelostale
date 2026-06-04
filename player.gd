extends CharacterBody2D

# Ajustamos las velocidades exactas que definiste
@export var velocidad_caminar: float = 60.0
@export var velocidad_correr: float = 120.0

@onready var animaciones = $CollisionShape2D/AnimatedSprite2D

# --- TU RAYCAST EXISTENTE ---
# Vinculamos el nodo RayCast2D que ya tienes en tu escena.
# IMPORTANTE: Asegúrate de que en el Inspector del RayCast2D la opción "Enabled" esté marcada.
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
		# Hacemos que la punta del RayCast mire exactamente hacia la dirección del movimiento
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

	# --- INTERACCIÓN CON EL LETRERO ---
	# Cuando el jugador presione el botón de Acción (Z / Enter)...
	if Input.is_action_just_pressed("acción"):
		# Verificamos si tu RayCast2D está colisionando con el letrero
		if detector.is_colliding():
			var objeto_chocado = detector.get_collider()
			
			# Si el objeto al que miras tiene el método para entregar texto (letrero_ejemplo.gd)
			if objeto_chocado and objeto_chocado.has_method("hablar"):
				# Buscamos el cuadro_dialogo que tienes instanciado en mapa_ejemplo_2.tscn
				var cuadro_dialogo = get_tree().current_scene.get_node_or_null("cuadro_dialogo")
				
				if cuadro_dialogo:
					# Congelamos al jugador inmediatamente al estilo Undertale
					puede_moverse = false 
					
					# Conectamos la señal para enterarnos de cuándo el jugador cierra el texto
					if not cuadro_dialogo.dialogo_terminado.is_connected(_on_dialogo_terminado):
						cuadro_dialogo.dialogo_terminado.connect(_on_dialogo_terminado)
					
					# Activamos el cuadro de diálogo pasándole el Array de datos de tu letrero
					cuadro_dialogo.iniciar_dialogo(objeto_chocado.hablar())

# --- FUNCIÓN DE RETORNO (CALLBACK) ---
# Esta función reacciona en automático cuando el script 'cuadro_dialogo.gd' emite el 'signal dialogo_terminado'
func _on_dialogo_terminado():
	await get_tree().create_timer(0.15).timeout
	puede_moverse = true
