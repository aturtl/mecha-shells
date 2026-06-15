@tool

class_name AttachmentSlot extends Node2D

@export_enum("Head","Shell","Tail","Foot") var type: int;
var number: int
var connected_attachment: Attachment = null

func _process(delta):
	queue_redraw()

func _draw(): # editor visualization
	if Engine.is_editor_hint():
		var color: Color
		
		match type:
			0: color = Color.RED
			1: color = Color.GREEN
			2: color = Color.BLUE
			3: color = Color.PURPLE
		
		draw_circle(Vector2.ZERO,5.0,color)

func set_new_attachment(attach: Attachment):
	if connected_attachment and connected_attachment != attach:
		connected_attachment.detach()
	connected_attachment = attach
	connected_attachment.detached.connect(on_attachment_detach)
	var attachment_array = SESSIONSTATS.stats.owned_attachments[attach.owned_index]
	attachment_array[1] = number
	SESSIONSTATS.save_stats()

func on_attachment_detach():
	connected_attachment.detached.disconnect(on_attachment_detach)
	if connected_attachment:
		var attachment_array = SESSIONSTATS.stats.owned_attachments[connected_attachment.owned_index]
		attachment_array[1] = -1
		SESSIONSTATS.save_stats()
	connected_attachment = null
