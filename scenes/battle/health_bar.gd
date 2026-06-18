class_name HealthBar extends Control

var current_health: float
var max_health: float

var connected_mech: Mech

var displayed = false

@export var scaler: Control


func update():
	scaler.scale.x = clamp(current_health/max_health, 0, 1)

func track_health(mech: Mech):
	max_health = mech.mech_stats.get_modifier("hp")
	mech.mech_stats.health_bar = self
