extends Node

# Referencia directa al Viewport donde corre el juego
@onready var sub_viewport = $SubViewportContainer/SubViewport

func _ready():
	add_to_group("reproductor_principal")
	cambiar_escena_interna("res://logo_inicio.tscn")

# SOLUCIÓN: Cambiamos queue_free() por free() para evitar bloqueos de nodos activos
func cambiar_escena_interna(ruta_escena: String):
	# 1. Eliminamos de forma INMEDIATA lo que esté en el Viewport
	for hijo in sub_viewport.get_children():
		hijo.queuefree() # <- Cambiado de queue_free() a free()
	
	# 2. Ahora que el Viewport está 100% vacío y limpio, instanciamos la nueva escena
	var nueva_escena = load(ruta_escena).instantiate()
	
	# 3. La metemos al Viewport sin conflictos
	sub_viewport.add_child(nueva_escena)
