extends RichTextLabel

func _ready() -> void:
	actualizar_mini_stats()

# Función para redibujar el NV, PS y ORO en tiempo real
func actualizar_mini_stats() -> void:
	text = "NV  " + str(Global.NV) + "\n" + "PS  " + str(Global.vida) +\
	"/" + str(Global.vidaMax) + "\n" + "OR  " + str(Global.oro)
