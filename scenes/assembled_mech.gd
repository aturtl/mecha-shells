extends CharacterBody2D


var gravity: float = -12

var action_velocity = Vector2.ZERO
var action_jump_velocity = Vector2.ZERO

var action_rot_velocity = 0.0

var g_velocity = 0.0

var bounce_velocity = Vector2(0,0)

@onready var action_timer = $ActionTimer
var max_wait = 1.5
var min_wait = .5

var current_action = Action.IDLE

var max_action_speed = 1000.0
var max_rotate_speed = 10.0

var initial_direction = Vector2.ZERO

var shake_amount: float = 0.0

@export var enemy: CharacterBody2D

@onready var screen_shake: Sprite2D = %ScreenShake

enum Action {
	IDLE,
	TACKLE,
	BACKUP,
	JUMP_AT,
	JUMP,
	DODGE,
	RANDOM_DIRECTION
}


func _ready():
	action_timer.timeout.connect(_on_action_timeout)
	set_new_action_time()


func _physics_process(delta):
	if enemy:
		handle_actions()
	
	wall_bounce()
	handle_gravity()
	compile_velocities()
	
	shake_amount = max(0,shake_amount - 1)
	
	screen_shake.material.set("shader_parameter/intensity",shake_amount)
	
	move_and_slide()


func wall_bounce():
	if is_on_wall(): #stop from sticking to walls
		initial_direction.x = -initial_direction.x
		action_velocity.x = -action_velocity.x
		bounce_velocity = get_wall_normal()*max_action_speed*2.0
		bounce_velocity.y = -1400.0
		action_rot_velocity /= 2.0
		
		add_screen_shake()
	else:
		bounce_velocity /= 1.2


func add_screen_shake():
	shake_amount += 10.0


func handle_actions():
	action_jump_velocity = Vector2.ZERO
	
	var norm_dir = position.direction_to(enemy.position).normalized()
	var dir_sign = sign(position.direction_to(enemy.position).x)
	
	var dir_dot_up = norm_dir.dot(Vector2(0,1))
	
	match current_action:
		Action.IDLE:
			action_velocity /= 1.2
		Action.TACKLE:
			action_velocity += initial_direction*12.0
			action_rot_velocity += dir_dot_up*.01
		Action.BACKUP:
			action_velocity.x -= initial_direction.x*12.0
		Action.JUMP_AT:
			action_jump_velocity -= Vector2(0,950.0)
			action_velocity += norm_dir*122.0
			action_rot_velocity += dir_dot_up*.0125
		Action.JUMP:
			action_jump_velocity -= Vector2(0,150.0)
		Action.DODGE:
			action_velocity -= norm_dir*3.0
			action_velocity.y = 10.0
			action_velocity += Vector2(randf_range(-5.0,5.0),randf_range(-5.0,5.0))
			action_rot_velocity += dir_dot_up*.005
		Action.RANDOM_DIRECTION:
			action_velocity += initial_direction * 5.0
			action_rot_velocity += initial_direction.dot(Vector2(0,1))*.001
	
	action_rot_velocity = clamp(action_rot_velocity,-max_rotate_speed,max_rotate_speed)
	
	if action_velocity.distance_to(Vector2(0,0)) > max_action_speed: #cap speed
		action_velocity = action_velocity.normalized()*max_action_speed


func handle_action_initial():
	var norm_dir = position.direction_to(enemy.position).normalized()
	var dir_sign = sign(position.direction_to(enemy.position).x)
	
	var dir_dot_up = norm_dir.dot(Vector2(0,1))
	
	match current_action:
		Action.IDLE:
			pass
		Action.TACKLE:
			initial_direction = norm_dir
		Action.BACKUP:
			initial_direction -= norm_dir
		Action.JUMP_AT:
			pass
		Action.JUMP:
			pass
		Action.DODGE:
			pass
		Action.RANDOM_DIRECTION:
			initial_direction = Vector2(randf(),randf()).normalized()


func compile_velocities():
	velocity = action_velocity + Vector2.DOWN*g_velocity + action_jump_velocity + bounce_velocity
	rotation += action_rot_velocity


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
	current_action = randi_range(0,Action.size()-1)
	handle_action_initial()
