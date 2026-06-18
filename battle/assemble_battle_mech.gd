class_name MechSetup extends Node2D

@onready var attachments_data = load("res://data/attachments_data.tscn").instantiate()

var mech: Mech = Mech.new()
var mech_stats: MechStats = MechStats.new()

var spawn_position = position

@onready var is_player = $IsPlayer

func setup_mech() -> Mech:
	assemble()
	mech.set_stats(mech_stats)
	parent_mech_items()
	return mech

func assemble():
	load_chassis()
	load_equipped_attachments()

func load_chassis():
	var equipped_chassis_name = SESSIONSTATS.stats.equipped_chassis
	var ec: Chassis = load("res://chasses/types/"+equipped_chassis_name+".tscn").instantiate()
	mech.add_child(mech_stats.equipped_chassis)
	mech_stats.equipped_chassis = ec

func load_equipped_attachments():
	await mech_stats.equipped_chassis.ready
	
	var i = 0
	
	for attachment_array in SESSIONSTATS.stats.owned_attachments:
		var attachment = attachments_data.find_child(attachment_array[0])
		if attachment and attachment is Attachment:
			var dup_attachment:Attachment = attachment.duplicate()
			dup_attachment.id_name = attachment_array[0]
			dup_attachment.owned_index = i
			dup_attachment.type = dup_attachment.Type.BATTLE
			var attached_to = attachment_array[1]
			if attached_to != -1 and attached_to < mech_stats.equipped_chassis.get_slot_count()-1:
				#equip
				print("EQUIPPING")
				dup_attachment.add_battle_behavior()
				dup_attachment.battle_behavior.modify_mech_stats(mech_stats)
				mech_stats.attachment_behaviors.append(dup_attachment.battle_behavior)
				mech_stats.equipped_attachments.append(dup_attachment)
				print("modify 01:", mech_stats.equipped_attachments)
				mech_stats.equipped_chassis.add_child(dup_attachment)
				dup_attachment.attach(mech_stats.equipped_chassis.get_slot_by_number(attached_to))
		i += 1
		


func parent_mech_items():
	mech.add_child(mech_stats.equipped_chassis)
	var cc = mech_stats.equipped_chassis.find_child("ChassisCollision")
	cc.name = "CC"
	if cc:
		cc.reparent(mech)
		mech.chassis_collision = cc
