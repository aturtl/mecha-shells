class_name ActionDodge extends Action


func action_began(info: ActionInfo) -> ActionInfo:
	return info


func action_looped(info: ActionInfo) -> ActionInfo:
	info.move_velocity -= info.direction_to_enemy*3.0
	info.move_velocity.y = 10.0
	info.move_velocity += Vector2(randf_range(-5.0,5.0),randf_range(-5.0,5.0))
	info.rot_velocity += info.direction_to_enemy.dot(Vector2(0,1))*.005
	return info


func get_debug_name() -> String:
	return "Dodge"
