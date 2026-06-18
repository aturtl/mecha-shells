class_name ActionJumpAt extends Action


func action_began(info: ActionInfo) -> ActionInfo:
	return info


func action_looped(info: ActionInfo) -> ActionInfo:
	info.jump_velocity -= Vector2(0,420.0)
	info.move_velocity += info.direction_to_enemy*64.0
	return info


func get_debug_name() -> String:
	return "Jump At"
