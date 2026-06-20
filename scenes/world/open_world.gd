extends Button

func _on_button_down():
	SceneLoader.play_sound("res://sound/selection.wav")
	SceneLoader.play_music("res://music/sunshine.mp3")
	SceneLoader.instantiate_file_with_loading_screen("res://scenes/world/world.tscn")
