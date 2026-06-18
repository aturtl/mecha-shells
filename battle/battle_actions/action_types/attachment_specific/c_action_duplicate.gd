class_name ActionDuplicate extends Action

var redirect_time = 1.0
var clone_life_time = 5.0

var max_clones = 5
var current_clone_count = 0

func action_began(info: ActionInfo) -> ActionInfo:
	while current_clone_count < max_clones:
		create_clone(info)
		current_clone_count += 1
	
	return info


func create_clone(info: ActionInfo):
	var dup_mech: Mech = info.mech.duplicate()
	
	dup_mech.modulate = Color(.5,.5,.5,.7)
	dup_mech.collision_layer = 0
	dup_mech.collision_mask = 0b10000
	
	dup_mech.perform_gravity = false
	dup_mech.enemy = info.mech.enemy
	
	info.mech.get_parent().add_child(dup_mech)
	
	var life_timer = Timer.new()
	var redirect_timer = Timer.new()
	info.mech.add_child(life_timer)
	info.mech.add_child(redirect_timer)
	
	dup_mech.action_info.move_velocity = Vector2.from_angle(randf_range(0,2*PI)) * 444.0
	
	redirect_timer.start(redirect_time)
	life_timer.start(clone_life_time)
	
	redirect_timer.timeout.connect(redirect_clone.bind(redirect_timer,dup_mech))
	life_timer.timeout.connect(delete_clone.bind(life_timer,dup_mech))
	dup_mech.hit_wall.connect(bounce_clone.bind(dup_mech))


func bounce_clone(clone: Mech):
	clone.action_info.move_velocity = -clone.action_info.move_velocity


func redirect_clone(redirect_timer: Timer, clone: Mech):
	print("redirection")
	clone.action_info.move_velocity = clone.position.direction_to(clone.enemy.position) * 800.0
	redirect_timer.queue_free()


func delete_clone(life_timer: Timer, clone: Mech):
	if life_timer:
		life_timer.queue_free()
	if clone:
		clone.queue_free()
		current_clone_count -= 1


func action_looped(info: ActionInfo) -> ActionInfo:
	return info


func get_debug_name() -> String:
	return "Duplicate"
