class_name ActionJump extends Action


func action_began(info: ActionInfo) -> ActionInfo:
	return info


func action_looped(info: ActionInfo) -> ActionInfo:
	info.jump_velocity -= Vector2(0,150.0)
	return info


func get_debug_name() -> String:
	return "Jump"
