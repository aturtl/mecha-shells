class_name ActionTackle extends Action


var initial_direction = Vector2(0,0)


func action_began(info: ActionInfo) -> ActionInfo:
	initial_direction = info.direction_to_enemy
	return info


func action_looped(info: ActionInfo) -> ActionInfo:
	info.move_velocity += initial_direction*12.0
	info.rot_velocity += initial_direction.dot(Vector2(0,1))*.01
	return info


func get_debug_name() -> String:
	return "Tackle"
