extends StaticBody2D

# Puedes cargar aquí retratos y audios específicos para este personaje
var voz = null

func hablar() -> Array:
	if not Global.moviste_archivos_para_estar_en_la_habitación_debug:
		# ACTIVAMOS LA CONDICIÓN: La próxima vez que hable, irá al 'else'
		Global.moviste_archivos_para_estar_en_la_habitación_debug = true
		
		return [
			{
				"texto": "* Hola... ",
				"retrato": null,
				"voz": voz
			},
			{
				"texto": "* Esto es para probar el sistema de dialogo, ya que estas en la sala debug.",
				"retrato": null,
				"voz": voz
			},
			{
				"texto": "* Espero no estes aquí cuando el juego este más avanzado.",
				"retrato": null,
				"voz": voz
			}
		]
	else:
		# Alineamos correctamente este bloque con un solo tabulador
		return [
			{
				"texto": "* Si ese es el caso... Significa que moviste los archivos.",
				"retrato": null,
				"voz": voz
			}
		]
