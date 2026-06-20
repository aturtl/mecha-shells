extends Node2D


@onready var levels_holder = load("res://levels/levels.tscn").instantiate()


signal levels_loaded

var last_level_completed: WorldLevel


func _ready():
	last_level_completed = get_children()[0]
	for world_level: WorldLevel in get_children():
		var level: Level = levels_holder.find_child(world_level.name)
		if level:
			world_level.level = level
			print("level status of ", level.name)
			if check_level_completion(level):
				last_level_completed = world_level
				world_level.complete()
				print("complete")
			elif check_level_unlocked(level):
				world_level.unlock()
				print("unlock")
			else:
				world_level.lock()
				print("lock")
	levels_loaded.emit()
		


func check_level_completion(level: Level):
	return level.name in SESSIONSTATS.default_stats.completed_levels


func check_level_unlocked(level: Level):
	return level.name in SESSIONSTATS.stats.unlocked_levels


func _on_start_button_down():
	var lv: WorldLevel = %MapTurtle.current_world_level
	if lv:
		lv.load_level_scene()
