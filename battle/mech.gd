class_name Mech extends CharacterBody2D

signal action_changed

var action_info: ActionInfo = ActionInfo.new()
var gravity: float = -12

var g_velocity = 0.0

var bounce_velocity: Vector2 = Vector2(0,0)

@onready var action_timer = Timer.new()
var max_wait = 1.5
var min_wait = .5

var current_action: Action

var max_action_speed = 1000.0
var max_rotate_speed = 10.0

var initial_direction = Vector2.ZERO

var shake_amount: float = 0.0

@export var enemy: Mech

@onready var screen_shake: Sprite2D = %ScreenShake

var mech_stats: MechStats
var chassis_collision

var do_overwrite_actions = false
var overwrite_actions = [
	ActionHover.new(),
	ActionTackle.new(),
	ActionDuplicate.new()
]

var perform_gravity = true

signal hit_wall
signal hit_enemy
signal death

var looping = true

var bounce_cd = 0

var activated = false

func on_death():
	looping = false
	death.emit()


func _ready():
	action_info.max_action_speed = max_action_speed
	
	if !mech_stats:
		mech_stats = MechStats.new()
		mech_stats.name = "DEFAULT"
	
	mech_stats.death.connect(on_death)
	
	if do_overwrite_actions:
		mech_stats.actions = overwrite_actions
	
	action_info.mech = self
	action_info.enemy_mech = enemy

	
	for behavior: BattleBehavior in mech_stats.attachment_behaviors:
		behavior.on_creation()
	
	setup_actions()
	set_behavior_variables()


func activate():
	begin_action_timer()
	activated = true


func begin_action_timer():
	add_child(action_timer)
	action_timer.timeout.connect(_on_action_timeout)
	set_new_action_time()


func _physics_process(delta):
	if !activated:
		return
	
	if bounce_cd > 0:
		bounce_cd -= 1
	
	correct_orientation()
	
	action_info.is_enemy_collision = false
	action_info.is_wall_collision = false
	
	loop_through_slide_collisions()
	
	handle_behavior_passives()
	
	if enemy and current_action:
		handle_actions()
	
	bounce_velocity.y /= 1.2
	
	handle_gravity()
	compile_velocities()
	
	if action_info.rot_velocity == 0:
		correct_orientation()
	
	
	for behavior: BattleBehavior in mech_stats.attachment_behaviors:
		behavior.passive()
	
	move_and_slide()


func correct_orientation():
	rotation = lerp(rotation, 0.0, .035)


func set_stats(stats: MechStats):
	mech_stats = stats


func wall_bounce(normal):
	if bounce_cd <= 0:
		print("BOUNCE")
		action_info.move_velocity.x = action_info.move_velocity.x
		g_velocity = normal*max_action_speed
		g_velocity.y = -500.0
		bounce_velocity = normal * 600
		bounce_velocity.y = -1400
		action_info.rot_velocity /= 2.0
		bounce_cd = 20


func handle_actions():
	action_info.jump_velocity = Vector2.ZERO
	
	action_info.direction_to_enemy = position.direction_to(enemy.position).normalized()
	
	current_action.action_looped()
	
	action_info.rot_velocity = clamp(action_info.rot_velocity,-max_rotate_speed,max_rotate_speed)
	
	if action_info.move_velocity.distance_to(Vector2(0,0)) > max_action_speed: #cap speed
		action_info.move_velocity = action_info.move_velocity.normalized()*max_action_speed


func on_wall_collision(collision: KinematicCollision2D):
	action_info.is_wall_collision = true
	action_info.wall_collision_normal = collision.get_normal()
	hit_wall.emit()
	wall_bounce(collision.get_normal())


func on_enemy_collision(collision: KinematicCollision2D):
	action_info.enemy_collision_normal = collision.get_normal()
	action_info.is_enemy_collision = true
	action_info.move_velocity = collision.get_normal() * 100.0
	hit_enemy.emit()
	wall_bounce(collision.get_normal())


func loop_through_slide_collisions():
	var num = get_slide_collision_count()
	
	var wall_collision = false
	var wall_collision_normal: Vector2
	
	var enemy_collision = false
	var enemy_collision_normal: Vector2
	
	for i in range(0, num):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		collision.get_collider_shape()
		if collider is WallBody:
			on_wall_collision(collision)
		if collider == enemy:
			on_enemy_collision(collision)
					
		if collider is Attachment and collider.battle_behavior and collider.battle_behavior.mech == enemy:
			collider.battle_behavior.on_contact()
			on_enemy_collision(collision)


func setup_actions():
	for action: Action in mech_stats.actions:
		action.action_setup(action_info)


func set_behavior_variables():
	var bbs = mech_stats.attachment_behaviors
	for bb: BattleBehavior in bbs:
		bb.enemy_mech = enemy
		bb.mech = self


func handle_behavior_passives():
	var bbs = mech_stats.attachment_behaviors
	for bb: BattleBehavior in bbs:
		bb.passive()


func compile_velocities():
	velocity = action_info.move_velocity + Vector2.DOWN*action_info.g_velocity + action_info.jump_velocity + bounce_velocity
	rotation += action_info.rot_velocity


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
	
	if current_action:
		current_action.action_ended()
	
	if mech_stats.actions.size() != 0:
		var ran = randi_range(0,mech_stats.actions.size()-1)
		current_action = mech_stats.actions[ran]
		current_action.action_began()
	
	if current_action:
		action_changed.emit(current_action.get_debug_name())
