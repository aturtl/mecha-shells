class_name Attachment extends Node2D

@export var control_marker: Control

@onready var drop_area: Area2D = $DropArea

@onready var connect_to_info = $ConnectTo

enum Type {
	UNASSIGNED,
	ASSEMBLY,
	BATTLE
}

var type = Type.UNASSIGNED

var id_name: String
var owned_index: int

# ASSEMBLY

var attached: bool = false
var dragging: bool = false

var drag_offset: Vector2

signal detached

# BATTLE

func _physics_process(delta):
	if Type.ASSEMBLY:
		manage_dragging_and_dropping()

func manage_dragging_and_dropping():
	var was_dragging = dragging
	
	dragging = (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and GlobalData.selected_mouse_area == drop_area)
	
	if !was_dragging and dragging: # determine offset
		drag_offset = get_global_mouse_position() - position
	
	if dragging:
		drag()
	
	if was_dragging and !dragging:
		GlobalData.selected_mouse_area = null
		drop()
	
	if !dragging and !attached and control_marker:
		position = control_marker.global_position
		visible = control_marker.is_visible_in_tree()

func drag():
	attached = false
	position = get_global_mouse_position() - drag_offset

func drop():
	var slot = get_slot()
	if slot:
		attach(slot)
	else:
		detach()

func replace_slot(slot: AttachmentSlot):
	slot.set_new_attachment(self)

func attach(slot: AttachmentSlot):
	attached = true
	replace_slot(slot)
	global_position = slot.global_position

func detach():
	attached = false
	detached.emit()

func get_slot() -> AttachmentSlot:
	for area in drop_area.get_overlapping_areas():
		if area is SlotArea:
			if connect_to_info.connect_to == area.get_parent().type:
				return area.get_parent()
	return null
