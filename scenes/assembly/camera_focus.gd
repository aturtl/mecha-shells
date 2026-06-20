class_name CameraFocus extends Node2D

@export var zoom: Vector2 = Vector2(1,1)

func _ready():
	var c = SceneLoader.get_camera()
	c.follow(self)
	c.set_global_zoom(zoom)
	
