extends Node

# Referencia directa al Viewport donde corre el juego
@onready var sub_viewport = $SubViewportContainer/SubViewport

func _ready():
	add_to_group("reproductor_principal")
	cambiar_escena_interna("res://logo_inicio.tscn")

# SOLUCIÓN: Usamos queue_free() pero de forma diferida para evitar bloqueos de hilos
func cambiar_escena_interna(ruta_escena: String):
	# 1. Le decimos a los hijos actuales del Viewport que se borren en cuanto queden libres
	for hijo in sub_viewport.get_children():
		hijo.queue_free()
	
	# 2. Instanciamos la nueva escena (Logo, Pantalla de Inicio o Mapa)
	var nueva_escena = load(ruta_escena).instantiate()
	
	# 3. TRUCO CRÍTICO: Usamos 'call_deferred' para añadir al hijo.
	# Esto le dice a Godot: "Espera un microsegundo a que terminen las señales actuales 
	# y luego mete la nueva escena al Viewport de forma segura".
	sub_viewport.call_deferred("add_child", nueva_escena)
