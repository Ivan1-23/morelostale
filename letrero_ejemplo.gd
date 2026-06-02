extends StaticBody2D

# Puedes cargar aquí retratos y audios específicos para este personaje
var voz_sans = null

func hablar() -> Array:
	# Retornamos un Array de Diccionarios con el formato de Undertale
	return [
		{
			"texto": "* Hola... Bienvenido a la sala debug.",
			"retrato": null,
			"voz": voz_sans
		},
		{
			"texto": "* Aquí es donde el programador prueba que las cosas no exploten.",
			"retrato": null,
			"voz": voz_sans
		},
		{
			"texto": "* ...Espero que tengas cuidado.",
			"retrato": null,
			"voz": voz_sans
		}
	]
