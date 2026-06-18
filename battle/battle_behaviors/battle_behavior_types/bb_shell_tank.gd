class_name BBShellTank extends BattleBehavior


func on_creation():
	print("mech created")


func on_contact(): #not incl yet
	print("mech contacted")


func passive():
	print("mech passive")


func modify_mech_stats(mech_stats: MechStats):
	print("mech modified")
	mech_stats.append_action(ActionExplosiveBullet.new(), 0)
	mech_stats.add_modifier("spd", -2)
	mech_stats.add_modifier("def", 6)
