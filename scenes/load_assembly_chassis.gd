extends Node2D

func _ready():
	var equipped_chassis_name = SESSIONSTATS.stats.equipped_chassis
	var ec = load("res://assembly/chasses/types/"+equipped_chassis_name+".tscn").instantiate()
	
	if ec:
		await add_child(ec)
	
	%AttachmentsManager.initial_setup()
