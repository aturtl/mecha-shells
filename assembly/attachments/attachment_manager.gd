extends Node

@onready var attachments_data = preload("res://data/attachments_data.tscn").instantiate()

@export var head_list: Control
@export var shell_list: Control
@export var tail_list: Control
@export var foot_list: Control

var equipped_chassis: Chassis

func initial_setup():
	await self.ready
	equipped_chassis = %Chassis.get_child(0)
	set_other_lists_invisible(head_list)
	load_owned_attachments()


func load_owned_attachments():
	var i = 0
	for attachment_array in SESSIONSTATS.stats.owned_attachments:
		var attachment = attachments_data.find_child(attachment_array[0])
		if attachment and attachment is Attachment:
			var dup_attachment:Attachment = attachment.duplicate()
			dup_attachment.id_name = attachment_array[0]
			dup_attachment.owned_index = i
			dup_attachment.type = dup_attachment.Type.ASSEMBLY
			var attached_to = attachment_array[1]
			if attached_to != -1:
				#equip
				dup_attachment.attach(equipped_chassis.get_slot_by_number(attached_to))
			assign_attachment_to_proper_list(dup_attachment)
		i += 1


func assign_attachment_to_proper_list(attachment: Attachment):
	match attachment.find_child("ConnectTo").connect_to:
		0:
			add_attachment_to_list(head_list, attachment)
		1:
			add_attachment_to_list(shell_list, attachment)
		2:
			add_attachment_to_list(tail_list, attachment)
		3:
			add_attachment_to_list(foot_list, attachment)


func add_attachment_to_list(list,attachment: Attachment):
	var marker: Control = Control.new()
	marker.custom_minimum_size = Vector2(100,94)
	list.find_child("HBoxContainer").add_child(marker)
	attachment.control_marker = marker
	%Attachments.add_child(attachment)
	

func set_other_lists_invisible(list):
	if list != head_list:
		head_list.visible = false
	if list != tail_list:
		tail_list.visible = false
	if list != shell_list:
		shell_list.visible = false
	if list != foot_list:
		foot_list.visible = false


func _on_head_button_down():
	head_list.visible = true
	set_other_lists_invisible(head_list)


func _on_shell_button_down():
	shell_list.visible = true
	set_other_lists_invisible(shell_list)


func _on_tail_button_down():
	tail_list.visible = true
	set_other_lists_invisible(tail_list)


func _on_foot_button_down():
	foot_list.visible = true
	set_other_lists_invisible(foot_list)
