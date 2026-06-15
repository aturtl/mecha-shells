extends Node2D

@onready var attachments_data = load("res://data/attachments_data.tscn").instantiate()

var equipped_chassis: Node2D

func _ready():
	assemble()

func assemble():
	load_chassis()
	load_equipped_attachments()

func load_chassis():
	var equipped_chassis_name = SESSIONSTATS.stats.equipped_chassis
	var ec = load("res://assembly/chasses/types/"+equipped_chassis_name+".tscn").instantiate()
	
	if ec:
		await add_child(ec)
		equipped_chassis = ec

func load_equipped_attachments():
	var i = 0
	
	for attachment_array in SESSIONSTATS.stats.owned_attachments:
		var attachment = attachments_data.find_child(attachment_array[0])
		if attachment and attachment is Attachment:
			var dup_attachment:Attachment = attachment.duplicate()
			dup_attachment.id_name = attachment_array[0]
			dup_attachment.owned_index = i
			dup_attachment.type = dup_attachment.Type.BATTLE
			var attached_to = attachment_array[1]
			if attached_to != -1:
				#equip
				print("EQUIPPING")
				equipped_chassis.add_child(dup_attachment)
				dup_attachment.attach(equipped_chassis.get_slot_by_number(attached_to))
		i += 1
