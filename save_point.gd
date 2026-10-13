extends StaticBody2D

# 1. Arrastra desde el FileSystem la escena de tu pantalla de guardado al Inspector
@export var escena_pantalla_guardado: PackedScene = preload("res://save_screen.tscn") # Ajusta la ruta a tu .tscn

# 2. Textos editables directamente desde el Inspector para cada punto de guardado del juego
@export var nombre_zona: String = "Ruinas"
@export var nombre_subzona: String = "Pasillo Principal"
@onready var sprite_animado: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D # Ajusta la ruta a tu nodo

func _ready() -> void:
	if sprite_animado:
		sprite_animado.play("animation") # Reemplaza por el nombre real de tu animación

# Esta función la llamará tu jugador al presionar la tecla de acción frente a la estrella
func interactuar(_jugador) -> void:
	# A. Actualizamos la ubicación en el diccionario de datos del Autoload
	GestorGuardado.datos_partida["zona_actual"] = nombre_zona
	GestorGuardado.datos_partida["subzona_actual"] = nombre_subzona
	
	# B. Verificamos que la escena de la pantalla de guardado esté asignada
	if escena_pantalla_guardado:
		# Instanciamos la pantalla de guardado
		var pantalla = escena_pantalla_guardado.instantiate()
		
		# La añadimos al árbol de nodos (se mostrará en pantalla)
		get_tree().root.add_child(pantalla)
	else:
		print("Error: No has asignado la escena_pantalla_guardado en el Inspector de la estrella.")
