class_name Attachment extends Node2D

@export_enum("Head","Shell","Tail","Foot") var connect_to: int;

@export var control_marker: Control

@onready var drop_area: Area2D = $DropArea

var attached: bool = false

var dragging: bool = false

signal detached

func _ready():
	pass

func _physics_process(delta):
	var was_dragging = dragging
	
	dragging = (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and GlobalData.selected_mouse_area == drop_area)
	
	if dragging:
		drag()
	
	if was_dragging and !dragging:
		GlobalData.selected_mouse_area = null
		drop()
	
	if !dragging and !attached and control_marker:
		position = control_marker.global_position
		visible = control_marker.is_visible_in_tree()

func drag():
	print("dragging")
	attached = false
	position = get_global_mouse_position()

func drop():
	var slot = get_slot()
	if slot:
		attached = true
		replace_slot(slot)
		position = slot.global_position
	else:
		detach()

func replace_slot(slot):
	slot.set_new_attachment(self)

func detach():
	attached = false
	detached.emit()

func get_slot() -> AttachmentSlot:
	for area in drop_area.get_overlapping_areas():
		if area is SlotArea:
			if connect_to == area.get_parent().type:
				return area.get_parent()
	return null
