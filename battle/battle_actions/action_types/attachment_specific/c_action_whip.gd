class_name ActionWhip extends Action

func action_began(info: ActionInfo) -> ActionInfo:
	return info


func action_looped(info: ActionInfo) -> ActionInfo:
	info.jump_velocity -= Vector2(0,950.0)
	info.move_velocity += info.direction_to_enemy*122.0
	info.rot_velocity += info.direction_to_enemy.dot(Vector2(0,1))*.0125
	return info


func get_debug_name() -> String:
	return "Whip"
