class_name ActionIdle extends Action


#func wall_bounce():
	#if is_on_wall(): #stop from sticking to walls
		#initial_direction.x = -initial_direction.x
		#action_info.move_velocity.x = action_info.move_velocity.x
		#bounce_velocity = get_wall_normal()*max_action_speed*2.0
		#bounce_velocity.y = -1400.0
		#action_info.rot_velocity /= 2.0
		#
		#add_screen_shake()
	#else:
		#bounce_velocity /= 1.2


func action_looped(info: ActionInfo) -> ActionInfo:
	info.move_velocity /= 1.2
	print("IDLE_LOOP")
	return info


func get_debug_name() -> String:
	return "Idle"
