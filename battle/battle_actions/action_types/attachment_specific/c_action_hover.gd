class_name ActionHover extends Action

var hover_speed: float = 125

var correction_amount: float = .07

func action_began(info: ActionInfo) -> ActionInfo:
	return info


func action_looped(info: ActionInfo) -> ActionInfo:
	var rot:float = info.mech.rotation
	
	rot = lerp(rot, 0.0, correction_amount)
	
	var dir = Vector2.from_angle(rot-PI/2)
	
	info.jump_velocity = dir*hover_speed
	info.move_velocity = Vector2.ZERO
	info.rot_velocity /= 2.0
	info.g_velocity.y = 0
	
	info.mech.rotation = rot
	
	return info


func get_debug_name() -> String:
	return "Hover"
