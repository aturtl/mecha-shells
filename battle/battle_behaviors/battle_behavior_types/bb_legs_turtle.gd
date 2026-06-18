class_name BBLegsTurtle extends BattleBehavior


func on_creation():
	print("mech created")


func on_contact(): #not incl yet
	print("mech contacted")


func passive():
	print("mech passive")


func modify_mech_stats(mech_stats: MechStats):
	mech_stats.append_action(ActionStabilize.new(), 0)
	mech_stats.add_modifier("spd", 1)
