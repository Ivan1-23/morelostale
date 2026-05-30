extends Node2D
 
@onready var camera = $Node2D/player/CollisionShape2D/Camera2D

func _ready():
	camera.limit_left = -265
	camera.limit_top = -66
	camera.limit_bottom = 164
	camera.limit_right = 468
