extends Control

func _ready():
	$AnimationPlayer.play("aparecer")

func _input(event):
	# Si el jugador presiona Z o X, se salta la intro
	if event.is_action_pressed("acción") or event.is_action_pressed("correr"):
		_on_animacion_terminada("")

@warning_ignore("unused_parameter")
func _on_animacion_terminada(anim_name: String):
	# MODIFICADO: Buscamos el reproductor principal para cambiar la escena por dentro del Viewport
	var reproductor = get_tree().get_first_node_in_group("reproductor_principal")
	if reproductor:
		reproductor.cambiar_escena_interna("res://pantalla_inicio.tscn")
	else:
		# Respaldo por si pruebas la escena del logo sola en el editor
		get_tree().change_scene_to_file("res://pantalla_inicio.tscn")
