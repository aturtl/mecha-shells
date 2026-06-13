class_name Attachment extends Node2D

@export_enum("Head","Shell","Tail","Foot") var connect_to: int;

@onready var drop_area: Area2D = $DropArea
@onready var hand = %Hand

var attached: bool = false

var dragging: bool = false

func _ready():
	pass

func _physics_process(delta):
	var was_dragging = dragging
	
	dragging = (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hand.selected_area == drop_area)
	
	if dragging:
		drag()
	
	if was_dragging and !dragging:
		print("huh")
		hand.deselect_area()
		drop()

func drag():
	attached = false
	position = get_global_mouse_position()

func drop():
	var slot_pos = get_slot_pos()
	if slot_pos:
		attached = true
		position = slot_pos
	else:
		attached = false
		position = Vector2(-480,75) # later replace by sending back to items

func get_slot_pos():
	for area in drop_area.get_overlapping_areas():
		if area is SlotArea:
			if connect_to == area.get_parent().type:
				return area.global_position
	return null
