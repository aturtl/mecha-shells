class_name Mech extends CharacterBody2D

signal action_changed

var action_info: ActionInfo = ActionInfo.new()
var gravity: float = -12

var g_velocity = 0.0

var bounce_velocity = Vector2(0,0)

@onready var action_timer = Timer.new()
var max_wait = 1.5
var min_wait = .5

var current_action: Action

var max_action_speed = 1000.0
var max_rotate_speed = 10.0

var initial_direction = Vector2.ZERO

var shake_amount: float = 0.0

@export var enemy: CharacterBody2D

@onready var screen_shake: Sprite2D = %ScreenShake

var mech_stats: MechStats

func _ready():
	print(name, "Ready")
	
	if !mech_stats:
		print("Added to", name)
		mech_stats = MechStats.new()
		mech_stats.name = "DEFAULT"
		
	for behavior: BattleBehavior in mech_stats.attachment_behaviors:
		behavior.on_creation()
	
	set_behavior_variables()
	
	add_child(action_timer)
	action_timer.timeout.connect(_on_action_timeout)
	set_new_action_time()


func _physics_process(delta):
	print(name, action_info.move_velocity, velocity)
	print(get_parent())
	
	handle_behavior_passives()
	
	if enemy and current_action:
		handle_actions()
	
	wall_bounce()
	handle_gravity()
	compile_velocities()
	
	shake_amount = max(0,shake_amount - 1)
	
	#screen_shake.material.set("shader_parameter/intensity",shake_amount)
	
	for behavior: BattleBehavior in mech_stats.attachment_behaviors:
		behavior.passive()
	
	print(name, "sliding and moving", position)
	move_and_slide()


func set_stats(stats: MechStats):
	mech_stats = stats


func wall_bounce():
	if is_on_wall(): #stop from sticking to walls
		initial_direction.x = -initial_direction.x
		action_info.move_velocity.x = action_info.move_velocity.x
		bounce_velocity = get_wall_normal()*max_action_speed*2.0
		bounce_velocity.y = -1400.0
		action_info.rot_velocity /= 2.0
		
		add_screen_shake()
	else:
		bounce_velocity /= 1.2


func add_screen_shake():
	shake_amount += 10.0


func handle_actions():
	action_info.jump_velocity = Vector2.ZERO
	
	action_info.direction_to_enemy = position.direction_to(enemy.position).normalized()
	
	current_action.action_looped(action_info)
	
	action_info.rot_velocity = clamp(action_info.rot_velocity,-max_rotate_speed,max_rotate_speed)
	
	if action_info.move_velocity.distance_to(Vector2(0,0)) > max_action_speed: #cap speed
		action_info.move_velocity = action_info.move_velocity.normalized()*max_action_speed	


func set_behavior_variables():
	var bbs = mech_stats.attachment_behaviors
	for bb: BattleBehavior in bbs:
		bb.enemy_mech = enemy
		bb.mech = self


func handle_behavior_passives():
	var bbs = mech_stats.attachment_behaviors
	print(bbs, "H7")
	for bb: BattleBehavior in bbs:
		bb.passive()


func compile_velocities():
	velocity = action_info.move_velocity + Vector2.DOWN*g_velocity + action_info.jump_velocity + bounce_velocity
	rotation += action_info.rot_velocity


func handle_gravity():
	if !is_on_floor():
		g_velocity -= gravity
	else:
		g_velocity = 0.0


func set_new_action_time():
	action_timer.start(randf_range(min_wait,max_wait))


func _on_action_timeout():
	randomize_action()
	set_new_action_time()


func randomize_action():
	if mech_stats.actions.size() == 0:
		return
	
	var ran = randi_range(0,mech_stats.actions.size()-1)
	current_action = mech_stats.actions[ran]
	action_info = current_action.action_began(action_info)
	
	if current_action:
		action_changed.emit(current_action.get_debug_name())
