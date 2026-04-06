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
	if not puede_moverse:
		velocity = Vector2.ZERO
		move_and_slide()
	var direccion = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		direccion.y -= 1
		mira.target_position = Vector2(0,-50)
		animación = "mov_top"
	elif mira.target_position == Vector2(0,-50):
		animación = "idle_top"
		
	if Input.is_action_pressed("ui_down"):
		direccion.y += 1
		mira.target_position = Vector2(0,50)
		animación = "mov_down"
	elif mira.target_position == Vector2(0,50):
		animación = "idle_down"
		
	if Input.is_action_pressed("ui_left"):
		direccion.x -= 1
		mira.target_position = Vector2(-50,0)
		animación = "mov_left"
	elif mira.target_position == Vector2(-50,0):
		animación = "idle_left"
		
	if Input.is_action_pressed("ui_right"):
		direccion.x += 1
		mira.target_position = Vector2(50,0)
		animación = "mov_right"
	elif mira.target_position == Vector2(50,0):
		animación = "idle_right"
	
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
