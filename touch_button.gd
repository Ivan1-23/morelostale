extends CanvasLayer
@onready var controles = $Control
var proxima_posicion_jugador: Vector2 = Vector2.ZERO

func _ready():
		# Detectamos si el jugador está en Android, iOS o Web Móvil
			if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
				# Si es celular, forzamos el modo EXPAND para liberar los controles táctiles
				get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
			else:
			# Si es PC (Windows, Mac, Linux, Web de escritorio), forzamos KEEP para mantener el 4:3
				get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
				controles.visible = false
