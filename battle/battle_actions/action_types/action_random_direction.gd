class_name ActionRandomDirection extends Action


var initial_direction = Vector2(0,0)


func action_began(info: ActionInfo) -> ActionInfo:
	initial_direction = Vector2(randf(),randf()).normalized()
	return info


func action_looped(info: ActionInfo) -> ActionInfo:
	info.move_velocity += initial_direction * 5.0
	info.rot_velocity += initial_direction.dot(Vector2(0,1))*.001
	return info


func get_debug_name() -> String:
	return "Random"
