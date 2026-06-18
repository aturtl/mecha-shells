class_name Mech extends CharacterBody2D

signal action_changed

var action_info: ActionInfo = ActionInfo.new()
var gravity: float = -12

var g_velocity = 0.0

var bounce_velocity = Vector2(0,0)

@onready var action_timer = Timer.new()
var max_wait = 3.0
var min_wait = 2.0

var current_action: Action

var max_action_speed = 1000.0
var max_rotate_speed = 10.0

var initial_direction = Vector2.ZERO

var shake_amount: float = 0.0

@export var enemy: CharacterBody2D

@onready var screen_shake: Sprite2D = %ScreenShake

var mech_stats: MechStats
var chassis_collision

var do_overwrite_actions = true
var overwrite_actions = [
	ActionHover.new(),
	ActionTackle.new(),
	ActionDuplicate.new()
]

var perform_gravity = true

signal hit_wall

func _ready():
	action_info.max_action_speed = max_action_speed
	
	print(name, "Ready")
	
	if !mech_stats:
		print("Added to", name)
		mech_stats = MechStats.new()
		mech_stats.name = "DEFAULT"
		
	if do_overwrite_actions:
		mech_stats.actions = overwrite_actions
	
	action_info.mech = self
	action_info.enemy_mech = enemy
	
	for behavior: BattleBehavior in mech_stats.attachment_behaviors:
		behavior.on_creation()
	
	set_behavior_variables()
	
func begin_action_timer():
	add_child(action_timer)
	action_timer.timeout.connect(_on_action_timeout)
	set_new_action_time()


func _physics_process(delta):
	loop_through_slide_collisions()
	
	print(name, action_info.move_velocity, velocity)
	print(get_parent())
	
	handle_behavior_passives()
	
	if enemy and current_action:
		handle_actions()
	
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


#func wall_bounce():
	#if is_on_wall(): #stop from sticking to walls
		#initial_direction.x = -initial_direction.x
		#action_info.move_velocity.x = action_info.move_velocity.x
		#bounce_velocity = get_wall_normal()*max_action_speed*2.0
		#bounce_velocity.y = -1400.0
		#action_info.rot_velocity /= 2.0
		#
		#add_screen_shake()
	#else:
		#bounce_velocity /= 1.2


func add_screen_shake():
	shake_amount += 10.0


func handle_actions():
	action_info.jump_velocity = Vector2.ZERO
	
	action_info.direction_to_enemy = position.direction_to(enemy.position).normalized()
	
	current_action.action_looped(action_info)
	
	action_info.rot_velocity = clamp(action_info.rot_velocity,-max_rotate_speed,max_rotate_speed)
	
	if action_info.move_velocity.distance_to(Vector2(0,0)) > max_action_speed: #cap speed
		action_info.move_velocity = action_info.move_velocity.normalized()*max_action_speed


func loop_through_slide_collisions():
	var num = get_slide_collision_count()
	
	var wall_collision = false
	
	var wall_collision_normal: Vector2
	
	for i in range(0, num):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		collision.get_collider_shape()
		if collider is WallBody:
			wall_collision_normal = collision.get_normal()
			wall_collision = true
	
	if wall_collision:
		hit_wall.emit()
	
	action_info.is_wall_collision = wall_collision
	action_info.wall_collision_normal = wall_collision_normal


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
	velocity = action_info.move_velocity + Vector2.DOWN*action_info.g_velocity + action_info.jump_velocity + bounce_velocity
	rotation += action_info.rot_velocity
	print(velocity)


func handle_gravity():
	if !perform_gravity:
		return
	if !is_on_floor():
		action_info.g_velocity.y -= gravity
	else:
		action_info.g_velocity.y = 0.0


func set_new_action_time():
	action_timer.start(randf_range(min_wait,max_wait))


func _on_action_timeout():
	randomize_action()
	set_new_action_time()


func randomize_action():
	if mech_stats.actions.size() != 0:
		var ran = randi_range(0,mech_stats.actions.size()-1)
		current_action = mech_stats.actions[ran]
		action_info = current_action.action_began(action_info)
	
	if current_action:
		action_changed.emit(current_action.get_debug_name())
