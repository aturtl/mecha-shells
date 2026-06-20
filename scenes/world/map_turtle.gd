extends AnimatedSprite2D


var speed: float = 200.0


enum State {
	STAND,
	WALK
}

var state = State.STAND


var current_walk_tween: Tween


var current_world_level: WorldLevel
@onready var level_menu = %LevelMenu

@onready var world_levels = %WorldLevels


func _ready():
	SceneLoader.camera.follow(self)
	initial_position()
	

func initial_position():
	var lv = world_levels.last_level_completed
	global_position = lv.global_position
	arrived_at_world_level(lv)


func set_world_level(lv: WorldLevel):
	current_world_level = lv


func set_state(state: int):
	if self.state != state:
		self.state = state
		match state:
			State.STAND:
				play("stand")
			State.WALK:
				play("walk")


func arrived_at_world_level(lv: WorldLevel):
	current_world_level = lv
	set_state(State.STAND)
	level_menu.set_text("Level "+lv.level_display + ": " + current_world_level.name_display)
	


func walk_to_world_level(lv: WorldLevel):
	if current_walk_tween:
		current_walk_tween.pause()
		current_walk_tween
	
	current_world_level = null
	
	var walk_tween = get_tree().create_tween()
	current_walk_tween = walk_tween
	var dist = lv.global_position.distance_to(global_position)
	var x_diff = lv.global_position.x - global_position.x
	flip_h = sign(x_diff) == -1
	var time = dist/speed
	if time > 3.0:
		time = 3.0 # don't want to be annoyingly long
	set_state(State.WALK)
	walk_tween.tween_property(self, "global_position", lv.global_position, time).set_trans(Tween.TRANS_LINEAR)
	walk_tween.play()
	await walk_tween.finished
	if walk_tween:
		arrived_at_world_level(lv)
