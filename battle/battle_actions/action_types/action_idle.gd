class_name ActionIdle extends Action


func action_looped(info: ActionInfo) -> ActionInfo:
	info.move_velocity /= 1.2
	print("IDLE_LOOP")
	return info


func get_debug_name() -> String:
	return "Idle"
