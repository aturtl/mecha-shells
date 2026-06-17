class_name BattleBehavior extends Node

var mech: Mech
var enemy_mech: Mech

func on_creation():
	print("mech created")


func on_contact(): #not incl yet
	print("mech contacted")


func passive():
	print("mech passive")


func modify_mech_stats(mech_stats: MechStats):
	print("mech modified")
