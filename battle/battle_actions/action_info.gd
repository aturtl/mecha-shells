class_name ActionInfo extends Node2D

var move_velocity: Vector2
var jump_velocity: Vector2
var rot_velocity: float

var g_velocity: Vector2

var direction_to_enemy: Vector2

var is_wall_collision = false
var wall_collision_normal: Vector2

var max_action_speed: float

var mech: Mech
var enemy_mech: Mech
