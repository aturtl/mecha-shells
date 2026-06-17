class_name ActionBackup extends Action

var initial_direction = Vector2(0,0)

func action_began(info: ActionInfo) -> ActionInfo:
	initial_direction = -info.direction_to_enemy
	return info


func action_looped(info: ActionInfo) -> ActionInfo:
	info.move_velocity.x -= initial_direction.x*12.0
	return info


func get_debug_name() -> String:
	return "Backup"
