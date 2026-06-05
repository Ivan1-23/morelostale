extends Button

func _ready() -> void:
	if not DisplayServer.is_touchscreen_available():
		self.visible = false
