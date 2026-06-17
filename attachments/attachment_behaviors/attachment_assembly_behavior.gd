class_name AssemblyBehavior extends Node2D

var dragging: bool = false
var drag_offset: Vector2

@onready var attachment: Attachment = get_parent()
@onready var drop_area: DropArea = attachment.drop_area
@onready var control_marker: Control = attachment.control_marker

func _physics_process(delta):
	manage_dragging_and_dropping()


func manage_dragging_and_dropping():
	var was_dragging = dragging
	
	dragging = (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and GlobalData.selected_mouse_area == drop_area)
	
	if !was_dragging and dragging: # determine offset
		drag_offset = get_global_mouse_position() - attachment.position
	
	if dragging:
		drag()
	
	if was_dragging and !dragging:
		GlobalData.selected_mouse_area = null
		drop()
	
	if !dragging and !attachment.attached and control_marker:
		attachment.position = control_marker.global_position
		attachment.visible = control_marker.is_visible_in_tree()


func drag():
	attachment.rotation = 0
	attachment.scale = Vector2(1,1)
	attachment.attached = false
	attachment.position = get_global_mouse_position() - drag_offset


func drop():
	var slot = attachment.get_slot()
	if slot:
		attachment.attach(slot)
	else:
		attachment.detach()
