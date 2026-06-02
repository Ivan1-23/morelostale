extends CharacterBody2D

#------------variables
var velocidad = 80
var velocidad_correr = 120
var animación = "mov_down" # Guarda la dirección actual
var hp:int = 20
var puede_moverse: bool = true 

@onready var animaciones = $CollisionShape2D/AnimatedSprite2D
@onready var mira = $CollisionShape2D/RayCast2D
@onready var menu = $menu
@onready var escenario_dialogo = preload("res://cuadro_dialogo.tscn")
var cuadro_dialogo_instancia = null

#------------movimiento
@warning_ignore("unused_parameter")
func _physics_process(delta):
# --- INTERACCIÓN ---
	if Input.is_action_just_pressed("acción") and puede_moverse:
		if mira.is_colliding():
			var objeto = mira.get_collider()
			if objeto.has_method("hablar"): 
				# Pausamos el movimiento del jugador
				puede_moverse = false
				
				# Instanciamos el cuadro de diálogo si no existe
				if cuadro_dialogo_instancia == null:
					cuadro_dialogo_instancia = escenario_dialogo.instantiate()
					get_tree().current_scene.add_child(cuadro_dialogo_instancia)
					# Nos conectamos a su señal para saber cuándo termina
					cuadro_dialogo_instancia.dialogo_terminado.connect(_on_dialogo_terminado)
				
				# Le pasamos los diálogos que el objeto/PNJ tiene guardados
				cuadro_dialogo_instancia.iniciar_dialogo(objeto.hablar())
	# --- CONTROL DE PAUSA / MENÚ ---
	if not puede_moverse:
		velocity = Vector2.ZERO
		if animaciones.animation.begins_with("mov_") or animaciones.animation.begins_with("run_"):
			# Si se pausa mientras corre o camina, lo mandamos a su respectivo idle
			var anim_idle = animaciones.animation.replace("mov_", "idle_").replace("run_", "idle_")
			animaciones.play(anim_idle)
		else:
			animaciones.stop()
		move_and_slide()
		return
		
	# --- OBTENER DIRECCIÓN ---
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Detectamos si el jugador quiere correr
	var esta_corriendo = Input.is_action_pressed("correr")
	var velocidad_actual = velocidad_correr if esta_corriendo else velocidad
	
	if direccion != Vector2.ZERO:
		# Determinar el sufijo de dirección (right, left, down, top)
		var sufijo_direccion = ""
		
		if abs(direccion.x) > abs(direccion.y):
			if direccion.x > 0:
				sufijo_direccion = "right"
				mira.target_position = Vector2(20, 0)
			else:
				sufijo_direccion = "left"
				mira.target_position = Vector2(-20, 0)
		else:
			if direccion.y > 0:
				sufijo_direccion = "down"
				mira.target_position = Vector2(0, 20)
			else:
				sufijo_direccion = "top"
				mira.target_position = Vector2(0, -20)
				
		# --- EL TRUCO DE LA ANIMACIÓN ---
		# Si corre, el prefijo cambia a "run_", si camina se queda en "mov_"
		var prefijo = "run_" if esta_corriendo else "mov_"
		animación = prefijo + sufijo_direccion
		
		animaciones.play(animación)
	else:
		# --- LÓGICA DE IDLE AUTOMÁTICO ---
		# Convierte cualquier estado de movimiento ("mov_" o "run_") a su versión "idle_"
		if animación.begins_with("mov_") or animación.begins_with("run_"):
			animación = animación.replace("mov_", "idle_").replace("run_", "idle_")
		
		animaciones.play(animación)
	
	# --- MOVIMIENTO FÍSICO ---
	velocity = direccion * velocidad_actual
	move_and_slide()
	# Agrega esta nueva función al final de tu player.gd
func _on_dialogo_terminado():
	puede_moverse = true
