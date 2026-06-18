class_name BBShellApple extends BattleBehavior


func on_creation():
	print("mech created")


func on_contact(): #not incl yet
	print("mech contacted")


func passive():
	print("mech passive")


func modify_mech_stats(mech_stats: MechStats):
	print("mech modified")
	mech_stats.append_action(ActionHeal.new(), 0)
	mech_stats.add_modifier("hp", 6)
	mech_stats.add_modifier("def", 1)
