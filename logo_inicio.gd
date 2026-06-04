extends Control

func _ready():
	$AnimationPlayer.play("aparecer")

func _input(event):
	# Si el jugador presiona Z o X, se salta la intro
	if event.is_action_pressed("acción") or event.is_action_pressed("correr"):
		_on_animacion_terminada()

func _on_animacion_terminada():
	get_tree().change_scene_to_file("res://pantalla_inicio.tscn")
