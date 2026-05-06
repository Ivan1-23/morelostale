extends CharacterBody2D

#------------variables
var velocidad = 80
var velocidad_correr = 120
var animación = ""
var hp:int = 20
var puede_moverse: bool = true # <--- NUEVA VARIABLE
@onready var animaciones = $CollisionShape2D/AnimatedSprite2D
@onready var mira = $CollisionShape2D/RayCast2D
@onready var menu = $menu


#------------movimiento
@warning_ignore("unused_parameter")
func _physics_process(delta):
	# --- INTERACCIÓN ---
	if Input.is_action_just_pressed("acción") and puede_moverse:
		if mira.is_colliding():
			var objeto = mira.get_collider()
			if objeto.has_method("hablar"): # Verifica si es un NPC con el que se puede hablar
				objeto.hablar()
	if not puede_moverse:
		velocity = Vector2.ZERO
		if animaciones.animation.begins_with("mov_"):
			var anim_idle = animaciones.animation.replace("mov_", "idle_")
			animaciones.play(anim_idle)
		else:
			animaciones.stop()
		return
		@warning_ignore("unreachable_code")
		move_and_slide()
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direccion != Vector2.ZERO:
		# Calculamos hacia dónde mira el jugador basándonos en el ángulo del vector
		# El ángulo se mide en radianes, así que usamos rangos de 45 grados.
		
		if abs(direccion.x) > abs(direccion.y):
			# Movimiento predominantemente horizontal
			if direccion.x > 0:
				animación = "mov_right"
				mira.target_position = Vector2(50, 0)
			else:
				animación = "mov_left"
				mira.target_position = Vector2(-50, 0)
		else:
			# Movimiento predominantemente vertical
			if direccion.y > 0:
				animación = "mov_down"
				mira.target_position = Vector2(0, 50)
			else:
				animación = "mov_top"
				mira.target_position = Vector2(0, -50)
	else:
		# Lógica de IDLE: Convertimos la última animación de "mov" a "idle"
		if animación.begins_with("mov_"):
			animación = animación.replace("mov_", "idle_")
	
	var velocidad_actual = velocidad
	
	if Input.is_action_pressed("correr"):
		velocidad_actual = velocidad_correr
	# ------------------------------
	
	velocity = direccion.normalized() * velocidad_actual
	
	move_and_slide()
	#reproducir animaciones
	if animación == "mov_top":
		animaciones.play("mov_top")
	if animación == "mov_down":
		animaciones.play("mov_down")
	if animación == "mov_left":
		animaciones.play("mov_left")
	if animación == "mov_right":
		animaciones.play("mov_right")
	if animación == "idle_top":
		animaciones.play("idle_top")
	if animación == "idle_down":
		animaciones.play("idle_down")
	if animación == "idle_left":
		animaciones.play("idle_left")
	if animación == "idle_right":
		animaciones.play("idle_right")
