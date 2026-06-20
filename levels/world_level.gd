class_name WorldLevel extends Control

@export var level_display = "?"
@export var name_display = "Unnamed Level"
@onready var button: TextureButton = $Button
var is_complete = false
var is_unlocked = false

var level: Level


func _ready():
	await %WorldLevels.levels_loaded
	print(name, is_unlocked)


func walk_to_level():
	# menu here
	
	print("opening")
	
	
	%MapTurtle.walk_to_world_level(self)


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
	button.button_down.connect(walk_to_level)
	is_unlocked = true
	modulate = Color(0.356, 0.494, 0.767, 1.0)


func lock():
	modulate = Color(0.91, 0.0, 0.412, 1.0)
