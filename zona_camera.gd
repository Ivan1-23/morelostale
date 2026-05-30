extends Area2D

func _ready():
	# Conectamos la señal de entrada del cuerpo físico
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Como ya configuramos las capas, sabemos que si entra aquí, es el jugador
	if body.name == "player":
		# Buscamos el nodo Camera2D que está dentro de tu jugador
		var camara = body.get_node_or_null("Camera2D") 
		var colision = $CollisionShape2D
		
		if camara and colision.shape is RectangleShape2D:
			# Obtenemos el tamaño del cuadro que dibujaste en el mapa
			var tamano = colision.shape.size
			var centro = colision.global_position
			
			# Calculamos las esquinas exactas en píxeles
			var izq = centro.x - (tamano.x / 2)
			var der = centro.x + (tamano.x / 2)
			var sup = centro.y - (tamano.y / 2)
			var inf = centro.y + (tamano.y / 2)
			
			# Modificamos los límites de la cámara con una transición suave
			var tween = create_tween().set_parallel(true)
			tween.tween_property(camara, "limit_left", izq, 0.4)
			tween.tween_property(camara, "limit_right", der, 0.4)
			tween.tween_property(camara, "limit_top", sup, 0.4)
			tween.tween_property(camara, "limit_bottom", inf, 0.4)
