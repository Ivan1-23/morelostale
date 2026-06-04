extends CharacterBody2D

# Ajustamos las velocidades exactas que me pediste
@export var velocidad_caminar: float = 60.0
@export var velocidad_correr: float = 120.0

@onready var animaciones = $CollisionShape2D/AnimatedSprite2D

# Esta es la variable clave que lee el menú
var puede_moverse: bool = true

func _ready():
	# Añadimos al jugador al grupo "player" automáticamente para que el menú lo encuentre siempre
	add_to_group("player")

func _physics_process(_delta):
	# Si el menú bloqueó al jugador, lo detenemos por completo y salimos
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
		
		# Control de animaciones Idle al soltar los controles
		var anim_actual = animaciones.animation
		if "right" in anim_actual: animaciones.play("idle_right")
		elif "left" in anim_actual: animaciones.play("idle_left")
		elif "down" in anim_actual: animaciones.play("idle_down")
		elif "top" in anim_actual: animaciones.play("idle_top")

	move_and_slide()
