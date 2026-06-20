class_name CameraUI extends Node2D


func _ready():
	if not SceneLoader.is_node_ready():
		await SceneLoader.ready
	var cam = SceneLoader.get_camera()
	cam.add_to_local(self)
	print("ADDED")
