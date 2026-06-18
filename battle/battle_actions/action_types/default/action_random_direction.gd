class_name ActionRandomDirection extends Action

var initial_direction = Vector2(0,0)


func wall_bounce(info: ActionInfo):
	if info.is_wall_collision:
		initial_direction.x = -initial_direction.x
		info.move_velocity = -info.move_velocity
		info.rot_velocity /= 2.0


func action_began(info: ActionInfo) -> ActionInfo:
	initial_direction = Vector2(randf(),randf()).normalized()
	return info


func action_looped(info: ActionInfo) -> ActionInfo:
	wall_bounce(info)
	info.move_velocity += initial_direction * 5.0
	info.rot_velocity += initial_direction.dot(Vector2(0,1))*.001
	return info


func get_debug_name() -> String:
	return "Random"
