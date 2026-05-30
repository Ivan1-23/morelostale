extends CanvasLayer

@onready var controles = $Control

func _ready():
	if not DisplayServer.is_touchscreen_available():
		controles.visible = false
