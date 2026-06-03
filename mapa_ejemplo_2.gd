extends Node2D
 
@onready var camera = $Node2D/player/CollisionShape2D/Camera2D
@onready var global = $"/root/Global"
func _ready():
	camera.limit_left = -265
	camera.limit_top = -66
	camera.limit_bottom = 164
	camera.limit_right = 468
	# Si estás probando el juego DESDE EL EDITOR de Godot, ignoramos el secreto
	if OS.is_debug_build():
		return # Corta aquí, no activa nada para que puedas testear en paz
	if not Global.inicio_correcto:
		Global.moviste_archivos_para_estar_en_la_habitación_debug = true
