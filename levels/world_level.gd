class_name WorldLevel extends Node2D

@onready var button: TextureButton = $Button
var is_complete = false

var level: Level

func open_level_menu():
	# menu here
	load_level_scene()
	

func load_level_scene():
	SceneLoader.play_sound("res://sound/success.wav")
	LevelInfo.enemy_id = level.enemy_id
	#level.location
	#get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
	SceneLoader.play_music("res://music/chainsaws.mp3", .5, -.3)
	SceneLoader.instantiate_file_with_loading_screen_shown("res://scenes/battle/battle.tscn")


func complete():
	unlock()
	is_complete = true
	modulate = Color(0.258, 0.566, 0.476, 1.0)


func unlock():
	button.button_down.connect(open_level_menu)
	modulate = Color(0.356, 0.494, 0.767, 1.0)


func lock():
	modulate = Color(0.91, 0.0, 0.412, 1.0)
