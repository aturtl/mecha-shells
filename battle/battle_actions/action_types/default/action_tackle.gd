class_name ActionTackle extends Action


var initial_direction = Vector2(0,0)


func wall_bounce(info: ActionInfo):
	if info.is_wall_collision:
		initial_direction.x = -initial_direction.x
		info.move_velocity = -info.move_velocity
		info.rot_velocity /= 2.0


func action_began(info: ActionInfo) -> ActionInfo:
	initial_direction = info.direction_to_enemy
	return info


func action_looped(info: ActionInfo) -> ActionInfo:
	#var rot_factor = initial_direction.angle_to(Vector2(-1,0))
	#var rot = info.mech.rotation
	
	wall_bounce(info)
	info.move_velocity += initial_direction*12.0
	info.rot_velocity /= 2.0
	
	#info.mech.rotation = lerp(rot, rot_factor, .1)
	#
	#info.mech.scale.x = sign(info.enemy_mech.position.x - info.mech.position.x)
	
	return info


func get_debug_name() -> String:
	return "Tackle"
