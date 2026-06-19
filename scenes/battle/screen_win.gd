class_name WinScreen extends Control


var is_active = false

@onready var cover = $Cover
@onready var buttons = $Buttons
@onready var btn_return: TextureButton = buttons.get_node("Return")
@onready var btn_next: TextureButton =  buttons.get_node("Continue")

func _ready():
	#visible = false
	cover.position.y = -900
	buttons.position.y = 648
	pass


func return_home():
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")


func btn_tween(btn):
	var tween = create_tween()
	tween.tween_property(btn, "position:y", -128, .7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()


func activate():
	btn_return.button_down.connect(return_home)
	
	print("Win Screen Activated")
	visible = true
	var screen_pos_tween = create_tween()
	var screen_rot_tween = create_tween()
	

	screen_pos_tween.tween_property(cover, "position", Vector2(0,0), 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	screen_pos_tween.play()
	await get_tree().create_timer(.2).timeout
	screen_rot_tween.play()
	
	await get_tree().create_timer(.05).timeout
	btn_tween(btn_return)
	
	await get_tree().create_timer(.1).timeout
	btn_tween(btn_next)
	
	print("finished")
	pass


func _physics_process(delta):
	if is_active:
		pass
