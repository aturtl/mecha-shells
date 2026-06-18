class_name BBTailMace extends BattleBehavior


func on_creation():
	print("mech created")


func on_contact(): #not incl yet
	print("mech contacted")


func passive():
	print("mech passive") #swing speed determines damage


func modify_mech_stats(mech_stats: MechStats):
	mech_stats.append_action(ActionSwingMace.new(), 0)
	mech_stats.add_modifier("spd", -1)
	mech_stats.add_modifier("def", 2)
