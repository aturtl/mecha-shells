extends Node

@export var display_action_statuses = false

@onready var p_mech_setup = MechSetup.new()
@onready var e_mech_setup = MechSetup.new()

@export var p_spawnpoint: Spawnpoint
@export var e_spawnpoint: Spawnpoint

var p_mech: Mech
var e_mech: Mech

@export var p_healthbar: HealthBar
@export var e_healthbar: HealthBar

func _ready():
	start_battle()
	
	if display_action_statuses:
		p_mech.action_changed.connect(_debug_p_action_changed)
		e_mech.action_changed.connect(_debug_e_action_changed)


func start_battle():
	build_mechs()
	setup_displays()
	spawn_mechs()


func setup_displays():
	p_healthbar.track_health(p_mech)
	e_healthbar.track_health(e_mech)
	p_healthbar.displayed = true
	e_healthbar.displayed = true


func build_mechs():
	p_mech = create_mech(p_mech_setup, p_spawnpoint.position)
	e_mech = create_mech(e_mech_setup, e_spawnpoint.position)
	
	print("ADDED")
	p_mech.enemy = e_mech
	e_mech.enemy = p_mech


func spawn_mechs():
	add_child(p_mech)
	add_child(e_mech)


func create_mech(setup: MechSetup, spawnpoint: Vector2):
	add_child(setup)
	var mech = setup.setup_mech()
	mech.position = spawnpoint
	
	return mech


func _debug_p_action_changed(action_name):
	%PlayerActionsDebug.text = "Player Action: " + action_name


func _debug_e_action_changed(action_name):
	%EnemyActionsDebug.text = "Enemy Action: " + action_name
