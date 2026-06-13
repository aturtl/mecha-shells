extends Node2D

@export var hand_default: Resource
@onready var interact_area: Area2D = $InteractArea

var mouse_just_pressed = true

func _ready():
	#Input.set_custom_mouse_cursor(hand_default) replace sprite and make more interactive
	pass

func _physics_process(delta):
	interact_area.position = get_global_mouse_position()
	if not GlobalData.selected_mouse_area and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouse_just_pressed:
			mouse_interact_check()
		mouse_just_pressed = false
	else:
		mouse_just_pressed = true

func mouse_interact_check():
	if GlobalData.selected_mouse_area:
		return
	for area in interact_area.get_overlapping_areas():
		if area is DropArea and area.is_visible_in_tree():
			GlobalData.selected_mouse_area = area
