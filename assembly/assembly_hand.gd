extends Node2D

@export var hand_default: Resource
@onready var interact_area: Area2D = $InteractArea

var selected_area: Area2D = null

func _ready():
	Input.set_custom_mouse_cursor(hand_default)

func _physics_process(delta):
	interact_area.position = get_global_mouse_position()
	if not selected_area and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		print("ok")
		mouse_interact_check()

func mouse_interact_check():
	if selected_area:
		return
	for area in interact_area.get_overlapping_areas():
		if area is DropArea:
			print("is")
			select_area(area)

func select_area(area: Area2D):
	selected_area = area

func deselect_area():
	selected_area = null
